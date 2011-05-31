class OrderedMenuItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :menu_item

  validates_presence_of :order_id
  validates_presence_of :menu_item_id
end
