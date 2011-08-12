class StudentOrdersController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!
  before_filter :get_student
  before_filter :verify_student_associated_with_current_user

  def new
    @student_order = StudentOrder.new_from_params(params)
  end

  def create
    @student_order = StudentOrder.new(params[:student_order])

    if @student_order.save
      redirect_to root_path, :notice => "Successfully placed order for #{@student.name}."
    else
      render :action => 'new'
    end
  end

  def edit
    @student_order = StudentOrder.find(params[:id])
  end

  def update
    @student_order = StudentOrder.find(params[:id])

    if @student_order.update_attributes(params[:student_order])
      redirect_to root_path, :notice => "Successfully updated order for #{@student.name}."
    else
      render :action => 'edit'
    end
  end

  private

  def get_student
    student_id_param = %w(new edit).include?(action_name) ?
        params[:student_id] : params[:student_order][:student_id]
    @student = Student.find(student_id_param)
  end

  def verify_student_associated_with_current_user
    unless current_user.account == @student.account
      flash[:alert] = 'Cannot place orders for students not associated with your account.'
      redirect_to root_url
    end
  end
end


