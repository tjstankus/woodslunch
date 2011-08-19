class UsersController < InheritedResources::Base

  def update
    update!(:notice => 'Successfully updated user information.') { dashboard_path }
  end
end