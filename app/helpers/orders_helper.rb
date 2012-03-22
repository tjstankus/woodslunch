module OrdersHelper

  def first_available_order_date
    Order.first_available_order_date
  end

  def available_order_months_first_dates
    first_date = first_available_order_date.beginning_of_month
    last_date = configatron.orders_last_available_on.beginning_of_month
    dates = Array.new((first_date.month..last_date.month).to_a.size)
    dates.size.times do |i|
      dates[i] = first_date + i.months
    end
    dates
  end

end