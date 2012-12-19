module OrdersHelper

  def first_available_order_date
    Order.first_available_order_date
  end

  def available_order_months_first_dates
    first_date = first_available_order_date.beginning_of_month
    last_date = configatron.orders_last_available_on.beginning_of_month
    date = first_date
    [].tap do |dates|
      until date > last_date
        dates << date
        date = date + 1.month
      end
    end
  end

end
