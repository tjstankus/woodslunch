class OrderPresenter

  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers

  attr_reader :month, :year, :first_of_next_month, :last_of_previous_month

  def initialize(month, year)
    @month = month.to_i
    @year = year.to_i
    @first_of_next_month = Date.civil(@year, @month, 1) + 1.month
  end

  def last_of_previous_month
    d = (Date.civil(@year, @month, 1) - 1.month)
    Date.civil(d.year, d.month, -1)
  end

  def display_month_and_year
    Date.civil(year, month, 1).strftime('%B %Y')
  end

  def display_previous_month?
    AppConfig.orderable_date?(last_of_previous_month)
  end

  def display_next_month?
    AppConfig.orderable_date?(first_of_next_month)
  end

end