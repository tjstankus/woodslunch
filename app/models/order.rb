class Order < ActiveRecord::Base
  belongs_to :student
  has_many :ordered_menu_items
  has_many :menu_items, :through => :ordered_menu_items

  validates :student_id, :presence => true
  validates :served_on, :presence => true
end
