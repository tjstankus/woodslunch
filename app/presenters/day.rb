class Day

  attr_reader :date, :object_for_display

  def initialize(date, obj, partial_name=nil)
    @date = date
    @object_for_display = obj
    @partial_name = partial_name
  end

  def month_day
    date.day
  end

  def day_name
    date.strftime('%A')
  end

  def name_for_partial
    @partial_name || object_for_display.class.to_s.underscore
  end
end