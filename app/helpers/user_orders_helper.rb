module UserOrdersHelper

  include OrdersHelper

  def link_to_current_user_order(user)
    date = first_available_order_date
    month = date.month
    year = date.year
    path = user_orders_path(user, :year => year, :month => month)
    link_to("Lunch order for #{user.name}", path)
  end
end