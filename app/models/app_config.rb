class AppConfig

  def self.orderable_date?(date)
    date >= configatron.orders_first_available_on &&
    date <= configatron.orders_last_available_on
  end

end