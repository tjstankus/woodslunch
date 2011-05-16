class MenuItem < ActiveRecord::Base

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false

  DEFAULT_PRICE = 4.00

end