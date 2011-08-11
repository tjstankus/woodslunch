module StudentOrdersHelper
  include OrdersHelper

  def link_to_current_student_order(student)
    date = first_available_order_date
    month = date.month
    year = date.year
    student_order = student.student_order_for_date(date)
    path = if student_order
             edit_student_order_path(student, student_order, :year => year, :month => month)
           else
             new_student_order_path(student, :year => year, :month => month)
           end
    link_to("Lunch order for #{student.name}", path)
  end
end