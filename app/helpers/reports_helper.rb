module ReportsHelper

  def display_menu_item_for_order(order, menu_item)
    if order.menu_items.include?(menu_item)
      ''.tap do |s|
        s << menu_item.short_name_or_name
        omi = order.ordered_menu_item_for_menu_item(menu_item)
        s << " (#{omi.quantity})" if omi.quantity > 1
      end
    end
  end

  def reports_for_grade(grade)
    return unless @orders[grade]
    ''.tap do |html|
      @orders[grade].each do |order|
        underscored_klass = order.class.to_s.underscore
        html << content_tag(:tr,
                            :id => underscored_klass + "_#{order.id}",
                            :class => cycle('odd', 'even') + " #{underscored_klass}") do
          content_tag(:td, order.last_name, :class => 'last_name') +
          content_tag(:td, order.first_name, :class => 'first_name') +
          content_tag(:td, order.grade, :class => 'grade') +
          ''.tap do |menu_items_html|
            @menu_items.each do |menu_item|
              menu_items_html << content_tag(:td, display_menu_item_for_order(order, menu_item), :class => 'menu_item')
            end
          end.html_safe
        end
      end
    end.html_safe
  end

end