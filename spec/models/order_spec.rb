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
end
