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
end
