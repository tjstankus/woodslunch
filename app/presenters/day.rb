class Day

  attr_reader :date, :object_for_display

  def initialize(date, obj)
    @date = date
    @object_for_display = obj
  end

  def month_day
    date.day
  end

  def day_name
    date.strftime('%A')
  end

  def name_for_partial
    object_for_display.class.to_s.underscore
  end
end