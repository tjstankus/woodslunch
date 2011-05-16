module Admin
	class BaseController < ApplicationController
    before_filter :verify_admin

    private

    def verify_admin
    	unless current_user && current_user.has_role?(:admin)
        redirect_to root_url
      end
    end
	end
end