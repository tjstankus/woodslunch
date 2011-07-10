module ApplicationHelper

  def header_link
    link_content = image_tag('logo.png') +
                   content_tag(:span, 'Lunch Program', :id => 'heading')
    link_to(link_content, root_path, :id => 'header_link')
  end

  def link_to_current_student_order(student)
    month = Date.today.month
    year = Date.today.year
    link_to("Lunch order for #{student.name}", edit_student_order_path(student,
      :year => year, :month => month))
  end

  def error_messages_for(model)
    if model.errors.any?
      content_tag(:div, :id => 'error_explanation') do
        content_tag(:h2, 'Errors')
        content_tag(:ul) do
          model.errors.full_messages.each do |msg|
            content_tag(:li, msg)
          end
        end
      end
    end
  end
end
