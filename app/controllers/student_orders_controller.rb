class StudentOrdersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verify_student_associated_with_current_user

  def edit
    @student_order = StudentOrder.new(params)
  end

  def create
    @student_order = StudentOrder.new(params['student_order'])
    if @student_order.save
      redirect_to(root_path,
        :notice => "Successfully placed order for #{@student_order.student.name}")
    else
      render :action => 'edit'
    end
  end

  private

  def verify_student_associated_with_current_user
    student = Student.find(params[:student_id] || params[:student_order][:orders]['1'][:student_id])
    unless current_user.account == student.account
      flash[:alert] = 'Cannot place orders for students not associated with your account.'
      redirect_to root_url
    end
  end

end
