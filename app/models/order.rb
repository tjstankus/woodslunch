class Order < ActiveRecord::Base
  belongs_to :student
  has_many :ordered_menu_items
  has_many :menu_items, :through => :ordered_menu_items

  validates :student_id, :presence => true
  validates :served_on, :presence => true

  def available_menu_items
    @available_menu_items ||= self.day_of_week_served_on.menu_items
  end

  def day_of_week_served_on
    DayOfWeek.find_by_name(self.served_on.strftime('%A'))
  end

end
