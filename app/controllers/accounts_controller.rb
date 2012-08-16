class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :verify_admin, :only => [:index, :with_balances]
  before_filter :verify_account_member

  def index
    @accounts = Account.search(params[:q])
  end

  def with_balances
    @accounts = Account.where('balance > 0').order('balance DESC')
  end
end
