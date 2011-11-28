class Order < ActiveRecord::Base

  has_many :ordered_menu_items, :dependent => :destroy
  has_many :menu_items, :through => :ordered_menu_items

  validates :served_on, :presence => true

  accepts_nested_attributes_for :ordered_menu_items,
      :reject_if => proc { |a| a['_destroy'].blank? && a['quantity'].blank? }, :allow_destroy => true

  # Returns an array of arrays. Each nested array contains Day objects that serve as wrappers.
  #
  # Missing weekdays at the beginning and end of the month are padded out with nils. So, if the
  # first day of the month is a Wednesday, for example, the returned object might look like this:
  #
  # [ [ nil,
  #     nil,
  #     day (wrapping an order for Wednesday),
  #     day (wrapping an order for Thursday),
  #     day (wrapping a day off) ],
  #   [ day (wrapping an order for Monday),
  #     day (wrapping an order for Tuesday),
  #     day (wrapping an order for Wednesday),
  #     day (wrapping an order for Thursday),
  #     day (wrapping an order for Friday), ],
  #   [ # remaining week arrays... ],
  #   [ # the last array (for last week of month) may have nils on the end ]
  # ]
  # TODO: This is such a candidate for refactoring
  def self.days_for_month_and_year_by_weekday(month, year, fk_id, current_user_is_admin=false)
    first_of_month = Date.civil(year.to_i, month.to_i, 1)
    last_of_month = Date.civil(year.to_i, month.to_i, -1)
    [].tap do |arr|
      first_of_month.upto(last_of_month) do |date|
        if date.weekday?
          arr << [] if start_new_array_for_week?(arr, date)

          prepend_nils_for_weekdays_before_first_of_month(arr, date, first_of_month)

          if !AppConfig.orderable_date?(date)
            arr.last << Day.new(date, nil, 'orders/unorderable_date')
          else
            if day_off = DayOff.for_date(date)
              arr.last << Day.new(date, day_off, 'orders/day_off')
            elsif date < first_available_order_date && !current_user_is_admin
              order = order_for_date(fk_id, date)
              arr.last << Day.new(date, order, 'orders/read_only')
            else
              order = order_for_date(fk_id, date)
              arr.last << Day.new(date, order)
            end
          end

          append_nils_for_weekdays_after_last_of_month(arr, date, last_of_month)
        end
      end
    end
  end

  def available_menu_items
    @available_menu_items ||= self.day_of_week_served_on.menu_items.reject do |menu_item|
      menu_item.inactive_on_date?(self.served_on)
    end
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

  def self.start_new_array_for_week?(arr, date)
    !arr.last || date.monday?
  end

  def self.prepend_nils_for_weekdays_before_first_of_month(arr, date, first_of_month)
    if date == first_of_month && !date.monday?
      (date.cwday - 1).times { arr.last << nil }
    end
  end

  def self.append_nils_for_weekdays_after_last_of_month(arr, date, last_of_month)
    if date == last_of_month && !date.friday?
      (5 - date.cwday).times { arr.last << nil }
    end
  end

  def self.create_order?(ordered_menu_items_attributes)
    atts = ordered_menu_items_attributes.values
    !(atts.collect{|h| h['quantity']}.all?{|q| q.empty?})
  end

  def self.reports_for(date)
    student_orders = StudentOrder.reports_for(date)
    user_orders = UserOrder.reports_for(date)
    orders = student_orders.merge(user_orders) { |k,o,n| o + n }
    orders.keys.each do |grade|
      orders[grade] = orders[grade].sort_by {|o| [o.last_name, o.first_name] }
    end
    orders
  end

  def quantity_by_menu_item
    {}.tap do |h|
      ordered_menu_items.each do |omi|
        if h[omi.menu_item]
          h[omi.menu_item] += omi.quantity
        else
          h[omi.menu_item] = omi.quantity
        end
      end
    end
  end

  def self.first_available_order_date
    start_date = [Date.today, configatron.orders_first_available_on].max
    if start_date.wday >= 1 && start_date.wday <= 5
      start_date.beginning_of_week + 1.week
    else
      start_date.beginning_of_week + 2.weeks
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

end
