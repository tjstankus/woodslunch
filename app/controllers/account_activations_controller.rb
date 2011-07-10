class AccountActivationsController < ApplicationController
  before_filter :find_account_request

  def new
    if params[:token] == @account_request.activation_token
      @account_activation = AccountActivation.new(params)
    else
      # TODO: Error message in flash
    end
  end

  def create
    @account_activation = AccountActivation.new(params['account_activation'])
    if @account_activation.save
      sign_in(@account_activation.user)
      redirect_to root_path
    else
      render :action => 'new'
    end
  end


  private

  def find_account_request
    @account_request = AccountRequest.find(params[:account_request_id])
  end

end