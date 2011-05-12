module ApplicationHelper

  def header_link
    link_content = image_tag('logo.png') + 
                   content_tag(:span, 'Lunch Ordering', :id => 'heading')
    link_to(link_content, root_path, :id => 'header_link')
  end
end
