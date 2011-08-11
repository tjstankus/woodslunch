require 'spec_helper'

describe StudentOrdersHelper do

  describe '#link_to_current_student_order' do

    let!(:student) { Factory(:student) }

    context 'given no student order for the first available order date' do
      it 'links to new student order' do
        student.student_orders.should be_empty
        helper.link_to_current_student_order(student).should include('new')
      end
    end

    context 'given an existing student order for the first available order date' do

      before(:each) do
        @starts_on = Date.parse('2011-09-01')
        student_order = Factory(:student_order,
                                :student => student,
                                :starts_on => '2011-09-01',
                                :ends_on => '2011-09-30')
      end

      it 'links to edit student order' do
        student.student_orders.first.starts_on.should == @starts_on
        helper.should_receive(:first_available_order_date).and_return(@starts_on)
        helper.link_to_current_student_order(student).should include('edit')
      end
    end
  end
end