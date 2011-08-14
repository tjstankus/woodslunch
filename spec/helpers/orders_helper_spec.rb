require 'spec_helper'

describe OrdersHelper do

  describe '#first_available_order_date' do

    context 'given today is a weekday' do

      it 'returns next monday' do
        Date.stub(:today).and_return(Date.parse('2011-09-01'))
        expected_date = Date.parse('2011-09-05')
        helper.first_available_order_date.should == expected_date
      end
    end

    context 'given today is a weekend day' do

      it 'returns two mondays from now' do
        Date.stub(:today).and_return(Date.parse('2011-09-03'))
        expected_date = Date.parse('2011-09-12')
        helper.first_available_order_date.should == expected_date
      end
    end
  end
end