require 'spec_helper'

describe UserOrder do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }


  let!(:user) { Factory(:user) }

  describe 'factory' do
    context 'given no args' do
      it 'builds a valid StudentOrder' do
        Factory.build(:user_order).should be_valid
      end
    end
  end

  # describe '.days_for_month_and_year_by_weekday' do

  #   let(:month) { '4' }
  #   let(:year) { '2011' }

  #   it 'returns an array of arrays' do
  #     days_by_weekday = StudentOrder.days_for_month_and_year_by_weekday(month, year, student.id)
  #     days_by_weekday.should be_an(Array)
  #     days_by_weekday.first.should be_an(Array)
  #   end

  #   context 'given a Friday as the first day of the month' do

  #     context 'the array representing the first week of the month' do

  #       let(:week) do
  #         StudentOrder.days_for_month_and_year_by_weekday(month, year, student.id).first
  #       end

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
