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
end
