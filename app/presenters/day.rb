class Day

  attr_reader :date, :wrapped_object

  def initialize(date, obj)
    @date = date
    @wrapped_object = obj
  end

  def month_day
    date.day
  end

  def day_name
    date.strftime('%A')
  end

  def name_for_partial
    wrapped_object.class.to_s.underscore
  end
end