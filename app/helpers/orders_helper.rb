module OrdersHelper

  def first_available_order_date
    start_date = [Date.today, configatron.orders_first_available_on].max
    if start_date.wday >= 1 && start_date.wday <= 5
      start_date.beginning_of_week + 1.week
    else
      start_date.beginning_of_week + 2.weeks
    end
  end

end