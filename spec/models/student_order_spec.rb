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
      
      it 'returns current year' do
        student_order.year.should == Date.today.year
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
      
      it 'returns current month' do
        student_order.month.should == Date.today.month
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
end
