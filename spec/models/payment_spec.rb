require 'spec_helper'

describe Payment do
  
  describe 'create' do
    it 'deducts amount from account balance' do
      account = Factory(:account)
      payment = Factory.build(:payment, :account => account)
      lambda {
        payment.save!
      }.should change { account.reload.balance }.by(-(payment.amount))
    end
  end
  
  describe 'destroy' do
   it 'adds amount back to account balance' do
      payment = Factory(:payment)
      lambda {
        payment.destroy
      }.should change { payment.account.reload.balance }.by(payment.amount)
    end
  end

end

