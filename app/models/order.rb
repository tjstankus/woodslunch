class Order < ActiveRecord::Base
  before_save :calculate_total
  # before_save :update_account_balance
  after_update :destroy_unless_menu_items

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

  def calculate_total
    self.total = self.menu_items.collect(&:price).inject { |sum, n| sum + n } 
  end

  # def update_account_balance
  #   
  # end

  def destroy_unless_menu_items
    self.destroy unless self.menu_items.any?
  end
end
