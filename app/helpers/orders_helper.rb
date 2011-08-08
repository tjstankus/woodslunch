module OrdersHelper

  def first_available_order_date
    today = Date.today
    if today.wday >= 1 && today.wday <= 5
      today.beginning_of_week + 1.week
    else
      today.beginning_of_week + 2.weeks
    end
  end

end