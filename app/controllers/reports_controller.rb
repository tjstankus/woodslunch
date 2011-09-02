class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin

  def index
    @date = params[:date]
    @orders = @date ? Order.find_all_by_served_on(@date) : []
  end
end