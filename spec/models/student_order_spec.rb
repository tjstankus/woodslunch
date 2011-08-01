require 'spec_helper'

describe StudentOrder do
  it { should validate_presence_of(:student_id) }
  it { should have_many(:orders) }
  it { should belong_to(:student) }

  describe 'factory' do
    context 'given no args' do
      it 'builds a valid StudentOrder' do
        Factory.build(:student_order).should be_valid
      end
    end
  end

  describe 'initialize' do

    context 'given year and month' do

      let(:params) { { :student_id => 1, :year => 2011, :month => 7 } }
      let(:student_order) { StudentOrder.new(params) }

      it 'sets starts_on' do
        student_order.starts_on.should == Date.parse('2011-07-01')
      end

      it 'sets ends_on'
    end
  end

  describe '.accepts_nested_attributes_for' do
    context 'orders' do
      it 'creates orders given valid nested attributes'
      it 'destroys orders'
      it 'only creates orders that have non-blank quantity attributes'
    end
  end

  it 'should update old specs' do
    pending
    # let(:student) { Factory(:student) }
    # let(:valid_params) { {'student_id' => student.id} }
    # let(:student_order) { StudentOrder.new(valid_params) }

    # describe '.initialize' do

    #   context 'given valid params' do
    #     it 'should be valid' do
    #       student_order.should be_valid
    #     end
    #   end

    #   context 'given invalid params' do
    #     it 'should not be valid' do
    #       so = StudentOrder.new({})
    #       so.should_not be_valid
    #       so.errors[:student_id].should_not be_blank
    #     end
    #   end

    #   it 'requires month'
    #   it 'requires year'
    # end

    # describe '#student' do
    #   it 'returns student' do
    #     student_order.student.should == student
    #   end
    # end

    # describe '#days_grouped_by_weekdays' do

    #   let(:month) { '4' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }

    #   it 'returns an array of arrays' do
    #     days_by_weekday = student_order.days_grouped_by_weekdays
    #     days_by_weekday.should be_an(Array)
    #     days_by_weekday.first.should be_an(Array)
    #   end

    #   context 'given a Friday as the first day of the month' do

    #     context 'the array representing the first week of the month' do

    #       let(:week) { student_order.days_grouped_by_weekdays.first }

    #       it 'has nils as its first four items' do
    #         (0..3).each { |i| week[i].should be_nil }
    #       end

    #       it 'has a Day as its last item' do
    #         week.last.should be_a(Day)
    #       end
    #     end
    #   end

    #   context 'given the first weekday starts in second week of month' do

    #     let!(:month) {'5'}

    #     context 'the array representing the first week of the month' do

    #       it 'should not contain all nils' do
    #         days_by_weekday = student_order.days_grouped_by_weekdays
    #         days_by_weekday.first.compact.should_not be_empty
    #       end
    #     end
    #   end

    #   # TODO: Day that should wrap a DayOff
    #   context 'given a day off for the first weekday' do

    #     let(:day_off) {
    #       Factory(:day_off, :starts_on => "#{year}-#{month}-1", :ends_on => "#{year}-#{month}-1")
    #     }

    #     context 'the day object for the first weekday' do
    #       it 'should wrap a DayOff'
    #     end
    #   end

    #   # TODO: Day that should wrap an Order
    # end

    # describe '#month' do

    #   let(:month) { '4' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }

    #   it 'delegates to MonthHelper' do
    #     student_order.month_helper.should_receive(:month)
    #     student_order.month
    #   end

    #   it 'returns the month as an integer' do
    #     student_order.month.should == month.to_i
    #   end
    # end

    # describe '#year' do

    #   let(:month) { '4' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }

    #   it 'delegates to MonthHelper' do
    #     student_order.month_helper.should_receive(:year)
    #     student_order.year
    #   end

    #   it 'returns the year as an integer' do
    #     student_order.year.should == year.to_i
    #   end
    # end

    # describe '#display_month_and_year' do

    #   let(:month) { '4' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }

    #   it 'returns long form string for month and year' do
    #     student_order.display_month_and_year.should == 'April 2011'
    #   end
    # end

    # describe '#save' do
    #   context 'given I have an existing order for the month and want to delete it' do
    #     pending
    #     # This will test that if we submit a form with the all the quantities blank it deletes an
    #     # existing order
    #   end
    # end

    # describe '#create_or_update_order' do
    #   let(:month) { '7' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }
    #   let(:order_params) {
    #     [ '1',
    #       { "ordered_menu_items"=>
    #         { "1"=>{"quantity"=>"2", "menu_item_id"=>"20"},
    #           "2"=>{"quantity"=>"", "menu_item_id"=>"21"},
    #           "3"=>{"quantity"=>"1", "menu_item_id"=>"5"} },
    #         "served_on"=>"2011-07-01",
    #         "student_id"=>"#{student.id}"} ]
    #   }

    #   context 'given an existing order for the month' do
    #     it 'updates the order' do
    #       student_order.create_or_update_order(order_params)
    #     end
    #   end

    #   context 'given no orders for the the month' do
    #     it 'creates the order'
    #   end
    # end

    # describe '#existing_order' do
    #   let(:month) { '7' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }
    #   let(:order_atts) { {"served_on"=>"2011-07-01", "student_id"=>"#{student.id}"} }

    #   context 'given an existing order for the student and served_on date' do
    #     let!(:order) {
    #       Factory(:order, :served_on => Date.civil(2011, 7, 1), :student_id => student.id)
    #     }

    #     it 'returns true' do
    #       student_order.existing_order(order_atts).should == order
    #     end
    #   end

    #   context 'given no order for the student and served_on date' do
    #     it 'returns false' do
    #       student_order.existing_order(order_atts).should be_nil
    #     end
    #   end
    # end

    # describe '#ordered_menu_items_with_quantity' do

    #   let(:month) { '4' }
    #   let(:year) { '2011' }
    #   let(:params) {{'student_id' => student.id, 'year' => year, 'month' => month}}
    #   let(:student_order) { StudentOrder.new(params) }
    #   let(:atts) {
    #     { "1"=>{"quantity"=>"2", "menu_item_id"=>"20"},
    #       "2"=>{"quantity"=>"", "menu_item_id"=>"21"},
    #       "3"=>{"quantity"=>"1", "menu_item_id"=>"5"} }
    #   }

    #   it 'filters out blank quantities' do |variable|
    #     student_order.ordered_menu_items_with_quantity(atts).should ==
    #         { "1"=>{"quantity"=>"2", "menu_item_id"=>"20"},
    #           "3"=>{"quantity"=>"1", "menu_item_id"=>"5"} }
    #   end
    # end
  end
end
