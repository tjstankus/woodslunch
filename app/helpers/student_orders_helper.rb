module StudentOrdersHelper
  include OrdersHelper

  def link_to_current_student_order(student)
    date = first_available_order_date
    month = date.month
    year = date.year
    link_to("Lunch order for #{student.name}", new_student_order_path(student,
      :year => year, :month => month))
  end
end