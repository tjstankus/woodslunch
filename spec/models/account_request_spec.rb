require 'spec_helper'

describe AccountRequest do
  it { should have_many(:requested_students) }
  it { should have_one(:account_invitation) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  it 'destroys dependent students'

  it 'validates format of email'

  describe '#state' do
    it 'initializes to pending' do
      AccountRequest.new.state.should == 'pending'
    end
  end

  describe '.pending' do
    context 'given two account requests in pending state' do

      before(:each) do
        @account_requests = [].tap do |a|
          2.times { a << Factory(:account_request) }
        end
      end

      it 'returns those two account requests' do
        @account_requests.each do |acc_req|
          AccountRequest.pending.should include(acc_req)
        end
      end
    end
  end

  describe '.approved' do
    context 'given two account requests in approved state' do

      before(:each) do
        @account_requests = [].tap do |a|
          2.times { a << Factory(:account_request, :state => 'approved') }
        end
      end

      it 'returns those two account requests' do
        @account_requests.each do |acc_req|
          AccountRequest.approved.should include(acc_req)
        end
      end
    end
  end

  describe '#approve!' do
    context 'given a pending account request' do

      let(:account_request) { Factory(:account_request) }

      it 'sets state to approved' do
        account_request.approve!
        account_request.state.should == 'approved'
      end

      it 'sets approved_at timestamp to now' do
        account_request.approved_at.should be_nil
        account_request.approve!
        account_request.approved_at.should be_a(ActiveSupport::TimeWithZone)
        account_request.approved_at.should be_within(1).of(Time.now)
      end

      it 'creates an associated AccountInvitation', :wip => true do
        lambda {
          account_request.approve!
        }.should change {account_request.account_invitation}.from(nil)
        account_request.account_invitation.should be_an(AccountInvitation)
      end
    end
  end
end
