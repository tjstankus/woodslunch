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
end