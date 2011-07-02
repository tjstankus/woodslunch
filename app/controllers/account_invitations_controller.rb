class AccountInvitationsController < InheritedResources::Base
  actions :create

  def create
    create! do |format|
      notice = "An account invitation has been sent to " +
          "#{resource.reload.account_request.email}"
      format.html {redirect_to(account_requests_path, :notice => notice )}
    end
  end
end