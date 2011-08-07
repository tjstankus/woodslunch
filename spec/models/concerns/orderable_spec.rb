require 'spec_helper'

class OrderableTest
  include Orderable
end

describe 'Orderable' do

  describe '.first_available_order_date' do

    let(:orderable) { OrderableTest.new }

    context 'given today is any day Monday through Friday' do
      it 'returns next Monday' do
        (5..9).each do |wday|
          today = Date.parse("2011-9-#{wday}")
          Date.stub(:today).and_return(today)
          next_monday = today.beginning_of_week + 1.week
          orderable.first_available_order_date.should == next_monday
        end
      end
    end

    context 'given today is Saturday' do
      it 'returns two Mondays from now' do
        today = Date.parse('2011-9-10')
        Date.stub(:today).and_return(today)
        Date.today.wday.should == 6
        two_mondays_from_now = today.beginning_of_week + 2.weeks
        orderable.first_available_order_date.should == two_mondays_from_now
      end
    end

    context 'given today is Sunday' do
      it 'returns two Mondays from now' do
        today = Date.parse('2011-9-11')
        Date.stub(:today).and_return(today)
        Date.today.wday.should == 0
        two_mondays_from_now = today.beginning_of_week + 2.weeks
        orderable.first_available_order_date.should == two_mondays_from_now
      end
    end
  end
end