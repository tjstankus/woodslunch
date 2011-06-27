class AccountRequestsController < InheritedResources::Base
  actions :index, :new, :create
  before_filter :verify_admin, :only => [:index]

  def create
    notice = 'Account request successfully submitted. Your request will be ' + 
             'reviewed within a few days. Upon approval, you will receive an ' + 
             'account activation email.'
    create!(:notice => notice) { root_path }
  end

end
