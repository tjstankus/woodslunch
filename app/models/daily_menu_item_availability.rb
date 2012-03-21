# NOTE: This class was designed to do more than it currently does. I imagine
#       that down the road there may be a need/request that would lead to a
#       temporary availability, so I added an ends_on attribute that we
#       currently expect to be nil. I can even foresee a request for multiple
#       temporary availabilities, in which case we'd need to guard against
#       overlapping timeframes and other manner of messiness. In fact, at that
#       point, it may be time to back up and think about refactoring menu
#       scheduling altogether.

class DailyMenuItemAvailability < ActiveRecord::Base
  belongs_to :daily_menu_item
  validates :daily_menu_item_id, :presence => true
  validates :starts_on, :presence => true
  validates :available, :presence => true

  def available_on_date?(date)
    raise NotImplementedError unless ends_on.blank?
    date >= starts_on ? available : !available
  end
end