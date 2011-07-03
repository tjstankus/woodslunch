require 'spec_helper'

describe AccountInvitation do
  it { should belong_to(:account_request) }
  it { should validate_presence_of(:account_request_id) }

  describe '#token' do
    it 'created before validation' do
      invite = AccountInvitation.new
      lambda {
        invite.valid?
      }.should change {invite.token}.from(nil)
    end
  end

  it 'sends email after create' do
    lambda {
      Factory(:account_invitation)
    }.should change {ActionMailer::Base.deliveries.size}.by(1)
  end
end