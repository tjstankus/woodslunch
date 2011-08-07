class StudentOrdersController < InheritedResources::Base
  before_filter :authenticate_user!
  # before_filter :verify_student_associated_with_current_user

  belongs_to :student

  # def new
  #   @student_order = StudentOrder.new
  #   new!
  # end

  # def edit
  #   @student_order = StudentOrder.new
  # end

  # def create
  #   @student_order = StudentOrder.new(params['student_order'])
  #   if @student_order.save
  #     redirect_to(root_path,
  #       :notice => "Successfully placed order for #{@student_order.student.name}")
  #   else
  #     render :action => 'edit'
  #   end
  # end

  private

  # def verify_student_associated_with_current_user
  #   student = Student.find(params[:student_id] || params[:student_order][:orders]['1'][:student_id])
  #   unless current_user.account == student.account
  #     flash[:alert] = 'Cannot place orders for students not associated with your account.'
  #     redirect_to root_url
  #   end
  # end

  def filtered_params
    HashWithIndifferentAccess.new.tap do |h|
      [:student_id, :year, :month].each do |att|
        h[att] = params[att]
      end
    end
  end

end
