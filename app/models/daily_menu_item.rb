class DailyMenuItem < ActiveRecord::Base
  belongs_to :day_of_week
  belongs_to :menu_item
  has_many :availabilities, :class_name => 'DailyMenuItemAvailability'

  validates :day_of_week_id, :presence => true
  validates :menu_item_id, :presence => true

  def available_on_date?(date)
    availabilities.empty? ? true : availabilities.first.available_on_date?(date)
  end
end
