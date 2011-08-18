require 'spec_helper'

describe StudentOrder do
  it { should validate_presence_of(:student_id) }
  it { should belong_to(:student) }

  describe 'factory' do
    context 'given no args' do
      it 'builds a valid StudentOrder' do
        Factory.build(:student_order).should be_valid
      end
    end
  end

  describe '.order_for_date' do
    context 'given a StudentOrder for the provided date' do
      it 'returns that StudentOrder'
    end

    context 'given no StudentOrder for the provided date' do
      it 'returns a new StudentOrder'
    end
  end

end
