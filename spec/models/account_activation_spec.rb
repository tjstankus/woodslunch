require 'spec_helper'

describe AccountActivation do

  it 'validates presence of account_request_id' do
    activation = AccountActivation.new({})
    activation.should_not be_valid
    activation.errors[:account_request_id].should_not be_blank
  end

  describe '#account_request' do

    let(:account_request) { Factory(:account_request) }

    it 'returns associated account_request' do
      pending
    end
  end

  context 'given an account request with two students' do
    before(:each) do
      @account_request = create_account_request(:students => 2)
    end

    it 'creates an account'
    it 'creates a user for the account'
    it 'creates two students for the account'
  end

end