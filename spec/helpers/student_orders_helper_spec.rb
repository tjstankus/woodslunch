require 'spec_helper'

describe StudentOrdersHelper do

  describe '#link_to_current_student_order' do

    let!(:student) { Factory(:student) }
    let!(:student_order) { Factory(:student_order, :student => student) }
    let(:first_available_date) { Date.parse('2011-09-01') }

    it 'links to the month of the first available order date' do
      helper.should_receive(:first_available_order_date).and_return(first_available_date)
      link = helper.link_to_current_student_order(student)
      link.should include("/students/#{student.id}/orders")
      link.should include('month=9')
      link.should include('year=2011')
    end
  end
end