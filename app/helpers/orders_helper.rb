module OrdersHelper

  def first_available_order_date
    Order.first_available_order_date
  end

end