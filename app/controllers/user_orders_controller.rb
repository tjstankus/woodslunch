class UserOrdersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  before_filter :get_user
  before_filter :verify_current_user_shares_account_with_user
  before_filter :redirect_unless_user_has_preferred_grade
  before_filter :get_presenter, :only => [:index]

  def index
    @days_by_week = UserOrder.days_for_month_and_year_by_weekday(params[:month], 
                                                                 params[:year], 
                                                                 @user.id,
                                                                 current_user.has_role?(:admin))
  end

  def create
    UserOrder.create_or_update_via_params(params[:user_orders])
    redirect_to root_path, :notice => "Successfully placed order for #{@user.name}."
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def verify_current_user_shares_account_with_user
    return true if current_user.has_role?(:admin)

    unless current_user.account == @user.account
      flash[:alert] = 'Cannot place orders for users not associated with your account.'
      redirect_to root_url
    end
  end

  def redirect_unless_user_has_preferred_grade
    unless @user.preferred_grade
      session[:redirect_to_after_setting_preferred_grade] = request.fullpath
      redirect_to edit_account_user_path(@user.account, @user),
          :alert => "Please set a preferred grade for this user to enable lunch ordering."
    end
  end

  def get_presenter
    @presenter = OrderPresenter.new(params[:month], params[:year])
  end

end
