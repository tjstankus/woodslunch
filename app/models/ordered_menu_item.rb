class OrderedMenuItem < ActiveRecord::Base

  MAX_DISPLAYED_QUANTITY = 3

  belongs_to :order
  belongs_to :menu_item

  # We don't have an order id when being created via accepts_nested_attributes_for
  # validates :order_id, :presence => true
  validates :menu_item_id, :presence => true
  validates :quantity, :presence => true, :numericality => true

  before_save :calculate_total
  after_destroy :destroy_order_unless_ordered_menu_items

  def calculate_total
    self.total = self.menu_item.price * self.quantity
  end

  def destroy_order_unless_ordered_menu_items
    order.destroy_unless_ordered_menu_items
  end

  # TODO: respond_to is a code smell
  def account
    @account ||= if order.respond_to?(:student)
      order.student.account
    elsif order.respond_to?(:user)
      order.user.account
    end
  end
end
