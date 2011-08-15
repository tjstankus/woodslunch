class UserOrder < Order
  belongs_to :user

  validates :user_id, :presence => true

  def self.order_for_date(user_id, date)
    find_by_user_id_and_served_on(user_id, date) ||
    UserOrder.new(:user_id => user_id, :served_on => date)
  end
end