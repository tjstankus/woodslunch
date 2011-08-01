require 'spec_helper'

describe Order do
  it { should have_many(:menu_items).through(:ordered_menu_items) }

  it { should validate_presence_of(:served_on) }

  describe 'minimal factory' do

    it 'should be valid' do
      Factory(:order).should be_valid
    end

    it 'should save without error' do
      lambda {
        Factory.build(:order).save!
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
      order = Factory.build(:order, :served_on => date)
      order.day_of_week_served_on.should == day_of_week
    end
  end

  describe 'available_menu_items' do
    before(:each) do
      today = Date.today
      day_of_week = DayOfWeek.find_or_create_by_name(today.strftime('%A'))
      @daily_menu_items = [].tap do |arr|
        3.times do
          arr << Factory(:daily_menu_item, :day_of_week => day_of_week)
        end
      end
      @order = Factory(:order, :served_on => today)
    end

    it 'returns all menu items available on served_on date' do
      menu_items = @daily_menu_items.collect(&:menu_item)
      available_menu_items = @order.available_menu_items
      menu_items.each do |menu_item|
        available_menu_items.should include(menu_item)
      end
    end
  end

  describe '#destroy_unless_ordered_menu_items' do

    let!(:ordered_menu_item) { Factory(:ordered_menu_item) }
    let!(:order) { ordered_menu_item.order.reload }

    context 'given associated ordered_menu_items' do

      it 'preserves record' do
        lambda {
          order.destroy_unless_ordered_menu_items
        }.should_not change {Order.count}
      end
    end

    context 'given no ordered_menu_items' do

      it 'destroys record' do
        id = order.id
        order.ordered_menu_items.clear
        lambda {
          order.destroy_unless_ordered_menu_items
        }.should change {Order.count}.by(-1)
        lambda {
          Order.find(id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#total' do
    it 'defaults to 0' do
      Factory(:order).total.should == 0
    end
  end

  describe '#update_total_and_account_balance' do
    let(:price) { 4.00 }
    let(:order) { Factory(:order) }
    let(:menu_item) { Factory(:menu_item, :price => price) }
    let(:ordered_menu_item) { Factory(:ordered_menu_item, :menu_item => menu_item, :order => order) }

    it 'updates the account balance' do
      lambda {
        order.update_total_and_account_balance
      }.should change { order.student.account.balance }.from(0).to(ordered_menu_item.menu_item.price)
    end

    context 'given quantity > 1 for associated ordered_menu_item' do
      it 'equals associated ordered menu item quantity * menu item price' do
        quantity = 2
        ordered_menu_item.quantity = quantity
        ordered_menu_item.save
        order.update_total_and_account_balance
        order.total.should == menu_item.price * quantity
      end
    end

    context 'when the order total has decreased' do
      it 'updates the account balance' do
        ordered_menu_item2 = Factory(:ordered_menu_item, :menu_item => menu_item, :order => order, :quantity => 2)
        order.update_total_and_account_balance
        ordered_menu_item2.quantity = 1
        ordered_menu_item2.save!
        order.update_total_and_account_balance
        order.total.should == price * 2
        order.student.account.balance.should == price * 2
      end
    end

    context 'when the order total has not changed' do

      it 'does not update the account balance' do
        account = order.student.account
        account.should_not_receive(:change_balance_by)
        order.save
        account.reload.balance.should == 0
      end
    end
  end

  describe 'when associated with student' do

    let(:student) { Factory(:student) }
    let(:order) { Factory(:order, :student => student) }

    it 'belongs to student' do
      order.student.should == student
    end

    it 'should not be associated with a user' do
      order.user.should be_nil
    end
  end

  describe 'when associated with user' do

    let(:user) { Factory(:user) }
    let(:order) { Factory(:order, :user => user) }

    it 'belongs to user' do
      order.user.should == user
    end

    it 'should not be associated with a student' do
      order.student.should be_nil
    end
  end

  it 'requires either a student or a user' do
    order = Factory.build(:order, :student => nil, :user => nil)
    order.student.should be_nil
    order.user.should be_nil
    order.should_not be_valid
    order.errors[:base].should include('Order must be associated with a student or a user, but not both.')
  end

  it 'invalidates with both a student and a user' do
    student = Factory(:student)
    user = Factory(:user)
    order = Factory.build(:order, :student => student, :user => user)
    order.should_not be_valid
    order.errors[:base].should include('Order must be associated with a student or a user, but not both.')
  end

  describe '#for' do
    it 'returns "student" when associated with a student' do
      student = Factory(:student)
      order = Factory(:order, :student => student)
      order.for.should == 'student'
    end

    it 'returns "user" when associated with a user' do
      user = Factory(:user)
      order = Factory(:order, :user => user, :student => nil)
      order.for.should == 'user'
    end
  end

  describe '#update_account_balance_if_total_changed' do

    let(:order) { Factory.build(:order) }

    it 'gets called on save' do
      order.should_receive(:update_account_balance_if_total_changed).once
      order.save
    end

    it 'calls account.change_balance_by on save when total changed' do
      order.total.should == 0
      order.total += 1
      account = order.get_account
      account.should_receive(:change_balance_by).once
      order.save
    end
  end
end
