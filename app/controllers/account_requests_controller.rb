class AccountRequestsController < InheritedResources::Base

  def create
    notice = 'Account request successfully submitted. Your request will be ' + 
             'reviewed within a few days. Upon approval, you will receive an ' + 
             'account activation email.'
    create!(:notice => notice) { root_path }
  end

end
