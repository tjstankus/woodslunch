class Order < ActiveRecord::Base
  belongs_to :student
  belongs_to :user
  has_many :ordered_menu_items, :dependent => :destroy
  has_many :menu_items, :through => :ordered_menu_items

  before_save :calculate_total
  before_save :update_account_balance_if_total_changed

  validates :served_on, :presence => true
  validate :associated_with_student_or_user

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

  private

  def associated_with_student_or_user
    unless (self.student || self.user) && !(self.student && self.user)
      errors.add(:base, 'Order must be associated with a student or a user, but not both.')
    end
  end

  def calculate_total
    self.total = self.menu_items.collect(&:price).inject(0) { |sum, n| sum + n }
  end

  def update_account_balance_if_total_changed
    if total_changed?
      diff = total - total_was
      account = self.student.account
      account.change_balance_by(diff)
    end
  end


end
