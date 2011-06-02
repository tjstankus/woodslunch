class StudentOrdersController < ApplicationController

  def edit
    @student_order = StudentOrder.new(params)
  end
end
