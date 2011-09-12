require 'spec_helper'

describe Payment do
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:amount) }

  describe 'create' do
    it 'deducts amount from account balance' do
      account = Factory(:account)
      payment = Factory.build(:payment, :account => account)
      amount = 20
      lambda {
        payment.update_attributes!(:amount => amount)
      }.should change { account.reload.balance }.by(-amount)
    end
  end

  describe 'destroy' do
    it 'credits amount back to account balance' do
      payment = Factory(:payment)
      lambda {
        payment.destroy
      }.should change { payment.account.reload.balance }.by(payment.amount)
    end
  end
end
