class UserOrdersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  before_filter :get_user
  before_filter :verify_current_user_associated_with_user
  before_filter :get_presenter, :only => [:index]

  def index
    @days_by_week = UserOrder.days_for_month_and_year_by_weekday(params[:month], params[:year], @user.id)
  end

  def create
    UserOrder.create_or_update_via_params(params[:user_orders])
    redirect_to root_path, :notice => "Successfully placed order for #{@user.name}."
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def verify_current_user_associated_with_user
    return true if current_user.has_role?(:admin)

    unless current_user.account == @user.account
      flash[:alert] = 'Cannot place orders for users not associated with your account.'
      redirect_to root_url
    end
  end

  def get_presenter
    @presenter = OrderPresenter.new(params[:month], params[:year])
  end
end