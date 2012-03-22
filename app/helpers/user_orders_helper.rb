module UserOrdersHelper

  include OrdersHelper

  def link_to_current_user_order(user, options={})
    options.reverse_merge!(:text => "Lunch order for #{user.name}")
    date = first_available_order_date
    month = date.month
    year = date.year
    path = user_orders_path(user, :year => year, :month => month)
    link_to(options[:text], path)
  end

  def link_to_user_month_order(user, date)
    month = date.month
    year = date.year
    path = user_orders_path(user, :year => year, :month => month)
    link_text = date.strftime('%B orders')
    link_to(link_text, path)
  end
end
