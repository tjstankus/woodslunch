class OrderedMenuItem < ActiveRecord::Base

  MAX_DISPLAYED_QUANTITY = 3

  belongs_to :order
  belongs_to :menu_item

  # validates :order_id, :presence => true
  validates :menu_item_id, :presence => true
  validates :quantity, :presence => true, :numericality => true

  # before_save :calculate_total
  # before_save :update_order_total_if_total_changed

  def calculate_total
    self.total = self.menu_item.price * self.quantity
  end

  def update_order_total_if_total_changed
    if total_changed?
      diff = total - total_was
      order.change_total_by(diff)
    end
  end
end
