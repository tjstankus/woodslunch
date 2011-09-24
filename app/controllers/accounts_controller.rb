class AccountsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :verify_admin, :only => [:index]
  before_filter :verify_account_member

  def index
    @accounts = Account.search(params[:q])
  end
end
