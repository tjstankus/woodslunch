module DateHelpers

  def next_month(year, month)
    m = month == 12 ? 1 : month + 1
    y = m == 1 ? year + 1 : year
    Date.civil(y,m,1)
  end

end
