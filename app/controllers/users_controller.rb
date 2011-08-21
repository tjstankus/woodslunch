class UsersController < InheritedResources::Base

  before_filter :authenticate_user!
  before_filter :verify_account_member

  def update
    update!(:notice => 'Successfully updated user information.') { account_path(resource) }
  end
end