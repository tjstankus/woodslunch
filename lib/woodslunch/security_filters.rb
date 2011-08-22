module Woodslunch
  module SecurityFilters

    def verify_admin
      unless current_user && current_user.has_role?(:admin)
        redirect_to root_url(:alert => "Permission denied to the requested resource.")
      end
    end

    def verify_account_member
      return true if current_user.has_role?(:admin)
      account = resource.is_a?(Account) ? resource : resource.account
      unless account == current_user.account
        redirect_to root_url(:alert => "Permission denied to the requested resource.")
      end
    end

  end
end