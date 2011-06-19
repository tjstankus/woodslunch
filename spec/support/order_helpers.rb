module OrderHelpers

  def create_menu_item_served_on_day(day)
    Factory(:daily_menu_item, :day_of_week => DayOfWeek.find_by_name(day))
  end

end
