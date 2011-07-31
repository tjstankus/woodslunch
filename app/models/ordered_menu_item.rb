class OrderedMenuItem < ActiveRecord::Base

  MAX_DISPLAYED_QUANTITY = 3

  belongs_to :order
  belongs_to :menu_item

  validates :order_id, :presence => true
  validates :menu_item_id, :presence => true
  validates :quantity, :presence => true, :numericality => true
end
