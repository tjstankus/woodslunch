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

end