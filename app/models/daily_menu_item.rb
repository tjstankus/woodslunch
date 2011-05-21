class DailyMenuItem < ActiveRecord::Base
  belongs_to :day_of_week
  belongs_to :menu_item

  validates :day_of_week_id, :presence => true
  validates :menu_item_id, :presence => true
end
