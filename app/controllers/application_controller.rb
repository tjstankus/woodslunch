class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def verify_admin
    unless current_user && current_user.has_role?(:admin)
      redirect_to root_url
    end
  end

end
