class DailyMenuItem < ActiveRecord::Base
  belongs_to :day_of_week
  belongs_to :menu_item
end