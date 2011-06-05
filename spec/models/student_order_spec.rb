require 'spec_helper'

describe StudentOrder do
  
  let(:student) { FactoryGirl.create(:student) }
  let(:valid_params) { {'student_id' => student.id} }
  let(:student_order) { StudentOrder.new(valid_params) }

  describe '.initialize' do

    context 'given valid params' do

      it 'should be valid' do
        student_order.should be_valid
      end
    end

    context 'given invalid params' do
      it 'should not be valid' do
        so = StudentOrder.new({})
        so.should_not be_valid
        so.errors[:student_id].should_not be_blank
      end
    end
  end

  describe '#student' do
    it 'returns student' do
      student_order.student.should == student
    end
  end

  describe '#year' do

    context 'given year in params' do

      let(:year) { '2010' }
      let(:student_order) { 
        StudentOrder.new('student_id' => student.id, 'year' => year) 
      }

      it 'returns provided year' do
        student_order.year.should == year
      end
    end

    context 'without year in params' do
      
      it 'returns nil' do
        student_order.year.should be_nil
      end
    end
  end

  describe '#month' do

    context 'given month in params' do

      let(:month) { '4' }
      let(:student_order) { 
        StudentOrder.new('student_id' => student.id, 'month' => month) 
      }

      it 'returns provided month' do
        student_order.month.should == month
      end
    end

    context 'without month in params' do
      
      it 'returns nil' do
        student_order.month.should be_nil
      end
    end
  end

  describe '#first_date_of_month' do
    
    let(:month) { '4' }
    let(:year) { '2011' }

    before(:each) do
      student_order.stub(:month).and_return(month)
      student_order.stub(:year).and_return(year)
    end

    it 'returns a Date object for the first day of the month' do
      expected_date = Date.civil(year.to_i, month.to_i, 1)
      student_order.first_date_of_month.should == expected_date
    end
  end

  describe '#orders_by_weekday' do

    let(:month) { '4' }
    let(:year) { '2011' }
    let(:params) { {'student_id' => student.id, 
                    'year' => year, 
                    'month' => month} }
    let(:student_order) { 
      StudentOrder.new(params)
    }

    it 'returns an array of arrays' do
      orders_by_weekday = student_order.orders_by_weekday
      orders_by_weekday.should be_an(Array)
      orders_by_weekday.first.should be_an(Array)
    end

    context 'given a Friday as the first day of the month' do
            context 'the array representing the first week of the month' do

        let(:week) { student_order.orders_by_weekday.first }

        it 'has nils as its first four items' do
          (0..3).each { |i| week[i].should be_nil }
        end

        it 'has an Order as its last item' do
          week.last.should be_an(Order)
        end
      end
    end
  end
end
