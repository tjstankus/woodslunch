class OrderPresenter

  attr_reader :month, :year

  def initialize(month, year)
    @month = month.to_i
    @year = year.to_i
  end

  def display_month_and_year
    Date.civil(year, month, 1).strftime('%B %Y')
  end
end