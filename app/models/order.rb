class Order < ActiveRecord::Base

  has_many :ordered_menu_items, :dependent => :destroy
  has_many :menu_items, :through => :ordered_menu_items

  validates :served_on, :presence => true
  validates :starts_on, :presence => true
  validates :ends_on, :presence => true
  # validate :associated_with_student_order_or_user_order

  accepts_nested_attributes_for :ordered_menu_items,
      :reject_if => proc { |a| a['_destroy'].blank? && a['quantity'].blank? }, :allow_destroy => true

  # after_save :calculate_total
  # after_save :update_account_balance_if_total_changed
  after_destroy :destroy_parent_order_unless_orders

  def available_menu_items
    @available_menu_items ||= self.day_of_week_served_on.menu_items
  end

  def quantity_for_menu_item(menu_item)
    if self.menu_items.include?(menu_item)
      self.ordered_menu_items.where('menu_item_id = ?', menu_item.id).first.quantity
    end
  end

  def ordered_menu_item_for_menu_item(menu_item)
    if menu_items.include?(menu_item)
      ordered_menu_items.where('menu_item_id = ?', menu_item.id).first
    end
  end

  def day_of_week_served_on
    DayOfWeek.find_by_name(self.served_on.strftime('%A'))
  end

  def destroy_unless_ordered_menu_items
    self.destroy unless self.ordered_menu_items.any?
  end

  def change_total_by(amount)
    self.total += amount
    self.save
  end

  def update_account_balance_if_total_changed
    if total_changed?
      diff = total - total_was
      account = get_account
      account.change_balance_by(diff)
    end
  end

  def get_account
    if self.student
      self.student.account
    elsif self.user
      self.user.account
    end
  end

  def destroy_parent_order_unless_orders
    if student_order
      student_order.destroy_unless_orders
    elsif user_order
      user_order.destroy_unless_orders
    end
  end

  def self.start_new_array_for_week?(arr, date)
    !arr.last || date.monday?
  end

  def self.prepend_nils_for_weekdays_before_first_of_month(arr, date, first_of_month)
    if date == first_of_month && !date.monday?
      (date.cwday - 1).times { arr.last << nil }
    end
  end

  def self.append_nils_for_weekdays_after_last_of_month(arr, date)
    if date == ends_on && !date.friday?
      (5 - date.cwday).times { arr.last << nil }
    end
  end

  # def update_total_and_account_balance
  #   self.total = self.ordered_menu_items.collect(&:total).inject(0) { |sum, n| sum + n }
  #   if total_changed?
  #     diff = total - total_was
  #     account = self.student.account
  #     account.change_balance_by(diff)
  #   end
  #   self.save
  # end

  # TODO: This may change with STI experiment.

  # private

  # def associated_with_student_order_or_user_order
  #   unless (self.student_order || self.user_order) && !(self.student_order && self.user_order)
  #     errors.add(:base, 'Order must be associated with a student_order or a user_order, but not both.')
  #   end
  # end
end
