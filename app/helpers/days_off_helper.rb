module DaysOffHelper
  def day_off_date(day_off)
    starts = day_off.starts_on.strftime("%A, %m-%d-%y")
    ends = day_off.ends_on.strftime("%A, %m-%d-%y")
    if day_off.starts_on == day_off.ends_on
      starts
    else
      "#{starts} &ndash; #{ends}".html_safe
    end
  end
end