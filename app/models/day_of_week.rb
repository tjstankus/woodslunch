class DayOfWeek < ActiveRecord::Base

  set_table_name 'days_of_week'

  NAMES = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

  has_many :daily_menu_items
  has_many :menu_items, :through => :daily_menu_items

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :name, :in => NAMES

  def self.weekdays
    self.limit(5)
  end
end