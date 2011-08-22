class AccountsController < InheritedResources::Base

  before_filter :verify_admin, :only => [:index]
  before_filter :verify_account_member
end