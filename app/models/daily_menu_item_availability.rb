class DailyMenuItemAvailability < ActiveRecord::Base
  belongs_to :daily_menu_item
  validates :daily_menu_item_id, :presence => true
  validates :starts_on, :presence => true
  validates :available, :presence => true
end