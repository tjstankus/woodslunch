require 'spec_helper'

class SecurityFiltersTest
  include Woodslunch::SecurityFilters
end

describe 'SecurityFilters' do

  let(:test_obj) { SecurityFiltersTest.new }
  let(:current_user) { double('current_user') }

  before(:each) do
    test_obj.stub(:current_user).and_return(current_user)
    test_obj.stub(:root_url).and_return(double('root_url'))
  end

  describe '#verify_admin' do

    it 'does not redirect when current user is an admin' do
      current_user.should_receive(:has_role?).with(:admin).and_return(true)
      test_obj.should_not_receive(:redirect_to)
      test_obj.verify_admin
    end

    it 'redirects when current user is not an admin' do
      current_user.should_receive(:has_role?).with(:admin).and_return(false)
      test_obj.should_receive(:redirect_to)
      test_obj.verify_admin
    end
  end

  describe '#verify_account_member' do

    it 'returns true if the current user is an admin' do
      current_user.should_receive(:has_role?).with(:admin).and_return(true)
      test_obj.should_not_receive(:redirect_to)
      test_obj.verify_account_member.should be_true
    end

    context 'given current user is not an admin' do

      let(:resource) { double('resource') }

      before(:each) do
        current_user.stub(:has_role?).and_return(false)
      end

      it 'redirects if the current user is not a member of the account' do
        test_obj.should_receive(:resource).and_raise('some error')
        test_obj.should_receive(:parent).and_return(nil)
        current_user.should_receive(:account).and_return(1)
        test_obj.should_receive(:redirect_to)
        test_obj.verify_account_member
      end

      it 'does not redirect if the current user is a member of the account' do
        resource.should_receive(:is_a?).and_return(Account)
        test_obj.should_receive(:resource).at_least(:once).and_return(resource)
        current_user.should_receive(:account).and_return(resource)
        test_obj.should_not_receive(:redirect_to)
        test_obj.verify_account_member
      end
    end
  end

end