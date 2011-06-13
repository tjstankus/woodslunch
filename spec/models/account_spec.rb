require 'spec_helper'

describe Account do
  it { should have_many(:users) }
  it { should have_many(:students) }

  describe '#change_balance_by' do
    
    it 'updates balance and saves' do
      account = FactoryGirl.build(:account)
      account.change_balance_by(1)
      account.reload.balance.should == 1
    end
  end
end
