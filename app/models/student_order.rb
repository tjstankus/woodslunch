class StudentOrder < Order

  belongs_to :student

  validates :student_id, :presence => true

  # accepts_nested_attributes_for :orders, :reject_if => :quantities_empty_unless_destroy?,
  #     :allow_destroy => true


  def self.new_from_params(params)
    params = filtered_params(params)
    year = params[:year].to_i
    month = params[:month].to_i
    student_order = StudentOrder.new(:student_id => params[:student_id]).tap do |student_order|
      student_order.starts_on = Date.civil(year, month, 1)
      student_order.ends_on = Date.civil(year, month, -1)
      student_order.days_by_weekday
    end
  end

  def self.filtered_params(params)
    HashWithIndifferentAccess.new.tap do |h|
      [:student_id, :year, :month].each do |att|
        h[att] = params[att]
      end
    end
  end

  # Returns an array of arrays. Each nested array contains Day objects that serve as wrappers for
  # an Order or a DayOff.
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
  def days_by_weekday
    @days ||= [].tap do |arr|
      starts_on.upto(ends_on) do |date|
        if date.weekday?
          arr << [] if start_new_array_for_week?(arr, date)

          prepend_nils_for_weekdays_before_first_of_month(arr, date)

          if day_off = DayOff.for_date(date)
            arr.last << Day.new(date, day_off)
          else
            push_order(arr.last, date)
          end

          append_nils_for_weekdays_after_last_of_month(arr, date)
        end
      end
    end
  end

  def self.days_for_month_and_year_by_weekday(month, year, student_id)
    first_of_month = Date.civil(year.to_i, month.to_i, 1)
    last_of_month = Date.civil(year.to_i, month.to_i, -1)
    [].tap do |arr|
      first_of_month.upto(last_of_month) do |date|
        if date.weekday?
          arr << [] if start_new_array_for_week?(arr, date)

          prepend_nils_for_weekdays_before_first_of_month(arr, date, first_of_month)

          if day_off = DayOff.for_date(date)
            arr.last << Day.new(date, day_off)
          else
            order = StudentOrder.find_by_student_id_and_served_on(student_id, date) ||
                    StudentOrder.new(:student_id => student_id, :served_on => date)
            arr.last << Day.new(date, order)
          end

          append_nils_for_weekdays_after_last_of_month(arr, date, last_of_month)
        end
      end
    end
  end

  # def push_order(arr, date)
  #   order = orders.find_by_served_on(date) || orders.build(:served_on => date)
  #   arr << Day.new(date, order)
  # end

  def quantities_empty_unless_destroy?(atts)
    omi_atts = atts['ordered_menu_items_attributes'].values
    if omi_atts.collect{|h| h['_destroy']}.compact.any?
      return false
    else
      omi_atts.collect{|h| h['quantity']}.all?{|q| q.empty?}
    end
  rescue NoMethodError
    return false
  end

  def destroy_unless_orders
    self.destroy unless self.orders.any?
  end

  # def init_starts_on_and_ends_on
  #   date = first_available_order_date
  #   self.starts_on ||= Date.civil(date.year, date.month, 1)
  #   self.ends_on ||= Date.civil(date.year, date.month, -1)
  # end
end

# # Presenter
# include ActiveModel::Validations
# include ActiveModel::Conversion
# extend ActiveModel::Naming
# def persisted?; false; end;

# attr_accessor :student_id, :orders, :month_helper
# delegate :month, :year, :to => :month_helper

# validates :student_id, :presence => true

# def initialize(params)
#   @orders = params['orders']
#   @student_id = params['student_id'] || student_id_from_orders
#   @month_helper = MonthHelper.new(params['month'], params['year'])
# end

# def student
#   @student ||= Student.find(student_id || student_id_from_orders)
# end

# def push_order(arr, date)
#   order = Order.find_by_student_id_and_served_on(student_id, date) ||
#           Order.new(:student_id => student_id, :served_on => date)
#   arr << Day.new(date, order)
# end

# def save
#   return false unless orders
#   orders.each {|order| create_or_update_order(order)}
# end

# def student_id_from_orders
#   orders.first.last['student_id'] if orders
# end

# def create_or_update_order(order_params)
#   order_atts = order_params.last
#   ordered_menu_items_atts = ordered_menu_items_with_quantity(order_atts.delete('ordered_menu_items'))
#   if order = existing_order(order_atts)
#     update_order(order, ordered_menu_items_atts)
#     order.destroy_unless_ordered_menu_items
#     # order.update_total_and_account_balance
#   elsif ordered_menu_items_atts.any?
#     order = Order.create!(order_atts)
#     create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
#     # order.update_total_and_account_balance
#   end
# end

# def existing_order(order_atts)
#   student_id = order_atts['student_id']
#   served_on = order_atts['served_on']
#   Order.find_by_student_id_and_served_on(student_id, served_on)
# end

# def update_order(order, ordered_menu_items_atts)
#   order.ordered_menu_items.clear
#   create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
# end

# def create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
#   ordered_menu_items_atts.each do |k, v|
#     order.ordered_menu_items.create(v)
#   end
# end

# def ordered_menu_items_with_quantity(atts)
#   atts.tap do |h|
#     h.each do |k,v|
#       h.delete(k) if v['quantity'].empty?
#     end
#   end
# end