class StudentOrder

  # Presenter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  def persisted?; false; end;

  attr_accessor :student_id, :orders, :month_helper
  delegate :month, :year, :to => :month_helper

  validates :student_id, :presence => true

  def initialize(params)
    @orders = params['orders']
    @student_id = params['student_id'] || student_id_from_orders
    @month_helper = MonthHelper.new(params['month'], params['year'])
  end

  def student
    @student ||= Student.find(student_id || student_id_from_orders)
  end

  def display_month_and_year
    month_helper.first_date.strftime('%B %Y')
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
  #
  def days_grouped_by_weekdays
    m = month_helper
    [].tap do |arr|
      m.first_date.upto(m.last_date) do |date|
        if date.weekday?
          arr << [] if m.start_new_array_for_week?(arr, date)

          m.prepend_nils_for_weekdays_before_first_of_month(arr, date)

          if day_off = DayOff.for_date(date)
            arr.last << Day.new(date, day_off)
          else
            push_order(arr.last, date)
          end

          m.append_nils_for_weekdays_after_last_of_month(arr, date)
        end
      end
    end
  end

  def push_order(arr, date)
    order = Order.find_by_student_id_and_served_on(student_id, date) ||
            Order.new(:student_id => student_id, :served_on => date)
    arr << Day.new(date, order)
  end

  def save
    return false unless orders
    orders.each {|order| create_or_update_order(order)}
  end

  def student_id_from_orders
    orders.first.last['student_id'] if orders
  end

  def create_or_update_order(order_params)
    order_atts = order_params.last
    ordered_menu_items_atts = ordered_menu_items_with_quantity(order_atts.delete('ordered_menu_items'))
    if order = existing_order(order_atts)
      update_order(order, ordered_menu_items_atts)
    elsif ordered_menu_items_atts.any?
      order = Order.create!(order_atts)
      create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
    end
  end

  def existing_order(order_atts)
    student_id = order_atts['student_id']
    served_on = order_atts['served_on']
    Order.find_by_student_id_and_served_on(student_id, served_on)
  end

  def update_order(order, ordered_menu_items_atts)
    order.ordered_menu_items.clear
    create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
  end

  def create_ordered_menu_items_for_order(order, ordered_menu_items_atts)
    ordered_menu_items_atts.each do |k, v|
      order.ordered_menu_items.create(v)
    end
  end

  def ordered_menu_items_with_quantity(atts)
    atts.tap do |h|
      h.each do |k,v|
        h.delete(k) if v['quantity'].empty?
      end
    end
  end
end
