class StudentOrdersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  before_filter :get_student
  before_filter :verify_student_associated_with_current_user
  before_filter :get_presenter, :only => [:index]

  def index
    @days_by_week = StudentOrder.days_for_month_and_year_by_weekday(params[:month], params[:year], @student.id)
  end

  def create
    StudentOrder.create_or_update_via_params(params[:student_orders])
    redirect_to root_path, :notice => "Successfully placed order for #{@student.name}."
  end

  private

  def get_student
    @student = Student.find(params[:student_id])
  end

  def verify_student_associated_with_current_user
    return true if current_user.has_role?(:admin)

    unless current_user.account == @student.account
      flash[:alert] = 'Cannot place orders for students not associated with your account.'
      redirect_to root_url
    end
  end

  def get_presenter
    @presenter = OrderPresenter.new(params[:month], params[:year])
  end
end


