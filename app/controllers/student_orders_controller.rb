class StudentOrdersController < ApplicationController

  before_filter :authenticate_user!

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
                                                          
end
