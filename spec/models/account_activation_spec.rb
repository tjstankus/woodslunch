require 'spec_helper'

describe AccountActivation do

  it 'validates presence of account_request_id' do
    activation = AccountActivation.new({})
    activation.should_not be_valid
    activation.errors[:account_request_id].should_not be_blank
  end

  describe '#account_request' do

    let(:account_request) { Factory(:account_request) }
    let(:account_activation) { AccountActivation.new(
        {'account_request_id' => account_request.id})}

    it 'returns associated account_request' do
      account_activation.account_request.should == account_request
    end
  end

  describe '#email' do
    let(:account_request) { Factory(:account_request) }
    let(:account_activation) { AccountActivation.new(
        {'account_request_id' => account_request.id})}

    it 'returns email from associated account request' do
      account_activation.email.should == account_request.email
    end
  end

  describe '#account' do
    it 'returns account'
  end

  describe '#user' do
    it 'returns user'
  end

  describe '#save' do
    before(:each) do
      @account_request = create_account_request(:students => 2)
      @account_request.approve!
      @account_activation = AccountActivation.new({
          'account_request_id' => @account_request.id,
          'password' => 'secret', 'password_confirmation' => 'secret'})
    end

    it 'creates an account' do
      lambda {
        @account_activation.save
      }.should change{ Account.count }.by(1)
    end

    it 'creates a user' do
      lambda {
        @account_activation.save
      }.should change{ User.count }.by(1)
    end

    it 'creates a user for the account' do
      @account_activation.save
      @account_activation.account.users.should_not be_empty
    end

    it 'creates students for the account' do
      @account_activation.save
      @account_activation.account.students.size.should == 2
    end

    context 'given mismatched passwords' do
      before(:each) do
        @account_activation = AccountActivation.new({
          'account_request_id' => @account_request.id,
          'password' => 'secret', 'password_confirmation' => 'badpassword'})
      end

      it 'returns false' do
        @account_activation.save.should be_false
      end

      it 'adds to errors' do
        @account_activation.save
        @account_activation.errors.should_not be_empty
      end
    end
  end


end