class PaymentsController < InheritedResources::Base
  belongs_to :account

  before_filter :authenticate_user!
  before_filter :verify_account_member

  def create
    create!(:notice => "Successfully created payment.") { account_payments_path(@account) }
  end

  def update
    update!(:notice => "Successfully updated payment.") { account_payments_path(@account) }
  end
end
