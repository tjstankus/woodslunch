class AccountRequestsController < InheritedResources::Base
  actions :index, :new, :create, :approve, :destroy
  before_filter :verify_admin, :except => [:new, :create]

  def create
    notice = 'Account request successfully submitted. Your request will be ' +
             'reviewed within a few days. Upon approval, you will receive an ' +
             'account activation email.'
    create!(:notice => notice) { root_path }
  end

  def approve
    resource.approve!
    redirect_to account_requests_path,
        :notice => "An account activation email has been sent to #{@account_request.email}"
  end
end
