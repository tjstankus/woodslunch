module ApplicationHelper

  def header_link
    link_content = image_tag('logo.png') + 
                   content_tag(:span, 'Lunch Program', :id => 'heading')
    link_to(link_content, root_path, :id => 'header_link')
  end

  def link_to_current_student_order(student)
    month = Date.today.month
    year = Date.today.year
    link_to("Lunch order for #{student.name}", student_order_path(student,
      :year => year, :month => month))
  end
end
