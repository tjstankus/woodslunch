require 'spec_helper'

describe Order do
  it { should belong_to(:student) }
  it { should have_many(:menu_items).through(:ordered_menu_items) }

  it { should validate_presence_of(:served_on) }
  it { should validate_presence_of(:student_id) }

  describe 'minimal factory' do
    
    it 'should be valid' do
      FactoryGirl.create(:order).should be_valid
    end

    it 'should save without error' do
      lambda {
        FactoryGirl.build(:order).save!
      }.should_not raise_error
    end
  end

  describe '#day_of_week_served_on' do
    
    it 'returns correct day of week' do
      year = Date.today.year.to_i
      month = Date.today.month.to_i
      first_weekday = (1..3).detect do |day|
        Date.civil(year, month, day).weekday?
      end
      date = Date.civil(year, month, first_weekday)
      day_name = date.strftime('%A')
      day_of_week = DayOfWeek.find_by_name(day_name)
      order = FactoryGirl.build(:order, :served_on => date)
      order.day_of_week_served_on.should == day_of_week
    end
  end

  describe 'available_menu_items' do
    before(:each) do
      today = Date.today
      day_of_week = DayOfWeek.find_or_create_by_name(today.strftime('%A'))
      @daily_menu_items = [].tap do |arr|
        3.times do
          arr << FactoryGirl.create(
            :daily_menu_item,
            :day_of_week => day_of_week)
        end
      end
      @order = FactoryGirl.create(:order, :served_on => today)
    end

    it 'returns all menu items available on served_on date' do
      menu_items = @daily_menu_items.collect(&:menu_item)
      available_menu_items = @order.available_menu_items
      menu_items.each do |menu_item|
        available_menu_items.should include(menu_item)
      end
    end
  end

  describe '#delete_if_no_menu_items' do

    let!(:order) { FactoryGirl.create(:order) }    
    let!(:id) { order.id }

    before(:each) do
      order.menu_items << FactoryGirl.create(:menu_item)
      order.save!
    end

    context 'given no menu_items' do
      
      it 'destroys record' do
        order.should have(1).menu_items
        lambda {
          order.update_attributes!(:menu_item_ids => [])
        }.should change {Order.count}.by(-1)
        lambda {
          Order.find(id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end  
    end
    
    context 'given menu items' do

      it 'preserves record' do
        menu_item = FactoryGirl.create(:menu_item)
        ids = order.menu_item_ids << menu_item.id
        lambda {
          order.update_attributes!(:menu_item_ids => ids)
        }.should_not change {Order.count}
        lambda {
          Order.find(id)
        }.should_not raise_error
      end
    end
  end

  describe '#total' do
    
    let(:menu_item) { FactoryGirl.create(:menu_item) }
    let(:order) { FactoryGirl.build(:order) }

    it 'defaults to 0' do
      order.total.should == 0  
    end

    context 'given one associated menu item' do

      it 'equals associated menu item price' do
        order.menu_items << menu_item
        order.save!
        order.total.should == menu_item.price
      end
    end

    context 'given several associated menu items' do
      
      it 'equals sum of associated menu item prices' do
        menu_items = [].tap { |a| a << FactoryGirl.create(:menu_item) }
        menu_items_total = menu_items.collect(&:price).inject { |sum, n| sum + n }
        menu_items.each { |menu_item| order.menu_items << menu_item }
        order.save!
        order.total.should == menu_items_total
      end
    end
  end

  describe '#update_account_balance_if_total_changed' do

    let(:menu_item) { FactoryGirl.create(:menu_item) }
    let(:order) { FactoryGirl.build(:order) }

    context 'when the order total has increased' do

      it 'updates the account balance' do
        order.menu_items << menu_item
        order.save!
        order.student.user.account.balance.should == menu_item.price
      end
    end

    context 'when the order total has decreased' do

      it 'updates the account balance' do
        menu_item2 = FactoryGirl.create(:menu_item)
        order.menu_items << menu_item
        order.menu_items << menu_item2
        order.save!
        order.student.user.account.balance.should == menu_item.price + 
            menu_item2.price
        order.menu_item_ids = [menu_item.id]
        order.save!
        order.reload
        order.student.user.account.balance.should == menu_item.price
      end
    end

    context 'when the order total has not changed' do
      
      it 'does not update the account balance' do
        account = order.student.user.account
        account.should_not_receive(:change_balance_by)
        order.save
        account.reload.balance.should == 0
      end
    end
  end
end
