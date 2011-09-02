require 'spec_helper'

describe Order do
  it { should have_many(:menu_items).through(:ordered_menu_items) }
  it { should validate_presence_of(:served_on) }

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
      order = Order.new(:served_on => date)
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
      @order = Factory(:student_order, :served_on => today)
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
        }.should_not change { Order.count }
      end

      it 'destroys order when ordered_menu_items are empty' do
        lambda {
          order.ordered_menu_items.clear
        }.should change { Order.count }.by(-1)
      end
    end
  end

  describe '.days_for_month_and_year_by_weekday' do

    let(:month) { '4' }
    let(:year) { '2011' }
    let!(:student) { Factory(:student) }

    it 'returns an array of arrays' do
      days_by_weekday = StudentOrder.days_for_month_and_year_by_weekday(month, year, student.id)
      days_by_weekday.should be_an(Array)
      days_by_weekday.first.should be_an(Array)
    end

    context 'given a Friday as the first day of the month' do

      context 'the array representing the first week of the month' do

        let(:week) do
          StudentOrder.days_for_month_and_year_by_weekday(month, year, student.id).first
        end

        it 'has nils as its first four items' do
          (0..3).each { |i| week[i].should be_nil }
        end

        it 'has a Day as its last item' do
          week.last.should be_a(Day)
        end

      end
    end
  end

  describe '#destroy' do
    context 'with associated ordered menu items' do

      let!(:ordered_menu_item) { Factory(:ordered_menu_item) }
      let(:order) { ordered_menu_item.order }
      let(:account) { order.student.account }
      let(:price) { ordered_menu_item.menu_item.price }

      it 'does not raise an error' do
        lambda {
          order.destroy
        }.should_not raise_error
      end

      it 'destroys order' do
        expect {
          order.destroy
        }.to change { Order.count }.by(-1)
      end

      it 'destroys ordered menu item' do
        expect {
          order.destroy
        }.to change { OrderedMenuItem.count }.by(-1)
      end

      it 'should change account balance' do
        expect {
          order.destroy
        }.to change { account.reload.balance }.by(-price)
      end
    end
  end
end
