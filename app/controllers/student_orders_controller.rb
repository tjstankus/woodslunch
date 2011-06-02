class StudentOrdersController < ApplicationController

  before_filter :authenticate_user!

  def edit
    @student_order = StudentOrder.new(params)
  end
end
