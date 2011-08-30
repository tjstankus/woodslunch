class UsersController < InheritedResources::Base
  belongs_to :account

  respond_to :html

  before_filter :authenticate_user!
  before_filter :verify_account_member

  def update
    update!(:notice => 'Successfully updated user information.') do
      if redir_path = session[:redirect_to_after_setting_preferred_grade]
        session[:redirect_to_after_setting_preferred_grade] = nil
        redir_path
      else
        account_path(parent)
      end
    end
  end
end