class Month

  attr_accessor :year, :month

  def initialize(date)
    @year = date.year.to_i
    @month = date.month.to_i
  end

  # def weekdays_grouped_by_week
  #   [].tap do |arr|
  #     first_date.upto(last_date) do |date|
  #       if date.weekday?
  #         arr << [] if start_new_array_for_week?(arr, date)

  #         prepend_nils_for_weekdays_before_first_of_month(arr, date)

  #         arr.last << OpenStruct.new(:month_day => date.day)

  #         append_nils_for_weekdays_after_last_of_month(arr, date)
  #       end
  #     end
  #   end
  # end

  # def first_date
  #   Date.civil(year, month, 1)
  # end

  # def last_date
  #   Date.civil(year, month, -1)
  # end

  def start_new_array_for_week?(arr, date)
    !arr.last || date.monday?
  end

  def prepend_nils_for_weekdays_before_first_of_month(arr, date)
    if date == first_date && !date.monday?
      (date.cwday - 1).times { arr.last << nil }
    end
  end

  def append_nils_for_weekdays_after_last_of_month(arr, date)
    if date == last_date && !date.friday?
      (5 - date.cwday).times { arr.last << nil }
    end
  end
end