class AccountActivationsController < ApplicationController
  before_filter :find_account_request

  def new
    if params[:token] == @account_request.activation_token
    else
    end
  end


  private

  def find_account_request
    @account_request = AccountRequest.find(params[:account_request_id])
  end

end