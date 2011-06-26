class AccountRequestsController < InheritedResources::Base
  def new
    @account_request = AccountRequest.new
    @account_request.requested_students.build
    new!
  end
end
