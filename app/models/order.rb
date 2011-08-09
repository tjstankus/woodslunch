class Order < ActiveRecord::Base
  belongs_to :student_order
  belongs_to :user_order

  has_many :ordered_menu_items, :dependent => :destroy
  has_many :menu_items, :through => :ordered_menu_items

  validates :served_on, :presence => true
  # validate :associated_with_student_or_user

  accepts_nested_attributes_for :ordered_menu_items, :reject_if => proc { |a| a['quantity'].blank? }

  # after_save :calculate_total
  # after_save :update_account_balance_if_total_changed

  def available_menu_items
    @available_menu_items ||= self.day_of_week_served_on.menu_items
  end

  def quantity_for_menu_item(menu_item)
    if self.menu_items.include?(menu_item)
      self.ordered_menu_items.where('menu_item_id = ?', menu_item.id).first.quantity
    end
  end

  def day_of_week_served_on
    DayOfWeek.find_by_name(self.served_on.strftime('%A'))
  end

  def for
    if self.student
      'student'
    elsif self.user
      'user'
    end
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

  # def update_total_and_account_balance
  #   self.total = self.ordered_menu_items.collect(&:total).inject(0) { |sum, n| sum + n }
  #   if total_changed?
  #     diff = total - total_was
  #     account = self.student.account
  #     account.change_balance_by(diff)
  #   end
  #   self.save
  # end

  # private

  # def associated_with_student_or_user
  #   unless (self.student || self.user) && !(self.student && self.user)
  #     errors.add(:base, 'Order must be associated with a student or a user, but not both.')
  #   end
  # end
end
