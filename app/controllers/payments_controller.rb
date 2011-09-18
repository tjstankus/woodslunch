class PaymentsController < InheritedResources::Base
  actions :index, :new, :create, :destroy
  belongs_to :account

  before_filter :authenticate_user!
  before_filter :verify_admin, :except => [:index]
  before_filter :verify_account_member

  def create
    create!(:notice => "Successfully created payment.") { account_payments_path(@account) }
  end
end
