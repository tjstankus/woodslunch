require 'spec_helper'

describe StudentOrder do
  it { should validate_presence_of(:student_id) }
  it { should belong_to(:student) }

  let!(:student) { Factory(:student) }

  describe 'factory' do
    context 'given no args' do
      it 'builds a valid StudentOrder' do
        Factory.build(:student_order).should be_valid
      end
    end
  end

  # describe '.new_from_params' do

  #   let(:year) { '2011' }
  #   let(:month) { '9' }
  #   let(:params) { {:student_id => student.id, :year => year, :month => month} }

  #   it 'calls days_by_weekday to build objects' do
  #     StudentOrder.any_instance.should_receive(:days_by_weekday)
  #     StudentOrder.new_from_params(params)
  #   end

  #   context 'given valid params' do

  #     let(:student_order) { StudentOrder.new_from_params(params) }

  #     it 'sets starts_on' do
  #       student_order.starts_on.should == Date.parse("#{year}-#{month}-1")
  #     end

  #     it 'sets ends_on' do
  #       student_order.ends_on.should == Date.parse("#{year}-#{month}-30")
  #     end
  #   end
  # end

  # describe '#days_by_weekday' do

  #   let(:month) { '4' }
  #   let(:year) { '2011' }
  #   let(:params) { {:student_id => student.id, :year => year, :month => month} }
  #   let(:student_order) { StudentOrder.new_from_params(params) }

  #   it 'returns an array of arrays' do
  #     days_by_weekday = student_order.days_by_weekday
  #     days_by_weekday.should be_an(Array)
  #     days_by_weekday.first.should be_an(Array)
  #   end

  #   context 'given a Friday as the first day of the month' do

  #     context 'the array representing the first week of the month' do

  #       let(:week) { student_order.days_by_weekday.first }

  #       it 'has nils as its first four items' do
  #         (0..3).each { |i| week[i].should be_nil }
  #       end

  #       it 'has a Day as its last item' do
  #         week.last.should be_a(Day)
  #       end
  #     end
  #   end
  # end

end
