require 'spec_helper'

describe UserOrder do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }


  let!(:user) { Factory(:user) }

  describe 'factory' do
    context 'given no args' do
      it 'builds a valid UserOrder' do
        Factory.build(:user_order).should be_valid
      end
    end
  end

  describe '.order_for_date' do
    context 'given a UserOrder for the provided date' do
      it 'returns that UserOrder'
    end

    context 'given no UserOrder for the provided date' do
      it 'returns a new UserOrder'
    end
  end

end
