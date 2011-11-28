class MenuItem < ActiveRecord::Base
  DEFAULT_PRICE = 4.00

  has_many :daily_menu_items, :dependent => :destroy
  has_many :days_of_week, :through => :daily_menu_items, :source => :day_of_week

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates :price, :presence => true,
                    :numericality => { :message => 'must be a number' }

  after_initialize :set_price_on_new_record

  def set_price_on_new_record
    self.price = DEFAULT_PRICE if self.new_record?
  end

  def self.unassigned_to_day
    where("id not in (select menu_item_id from daily_menu_items)")
  end

  def short_name_or_name
    short_name || name
  end

  def inactive_on_date?(date)
    inactive_starts_on? && inactive_starts_on <= date
  end
end
