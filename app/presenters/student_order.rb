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

  # Returns an array of arrays. Each nested array contains order objects for
  # weekdays in the month. For example:
  #
  # [ [ mon_date_order,
  #     tue_date_order,
  #     wed_date_order,
  #     thu_date_order,
  #     fri_date_order ],
  #   [ mon_date_order,
  #     tue_date_order,
  #     wed_date_order,
  #     thu_date_order,
  #     fri_date_order ]
  # ]
  #
  # Missing weekdays are padded out with nils. So, if the first day of the
  # month is a Wednesday, for example, the first embedded array will look like
  # this:
  #
  # [nil, nil, wed_date_order, thu_date_order, fri_date_order]
  #
  # If the last day of the month is a Thursday, the last embedded array will
  # look like this:
  #
  # [mon_date_order, tue_date_order, wed_date_order, thu_date_order, nil]
  def days_grouped_by_weekdays
    m = month_helper
    [].tap do |arr|
      m.first_date.upto(m.last_date) do |date|
        if date.weekday?
          arr << [] if m.start_new_array_for_week?(arr, date)

          m.prepend_nils_for_weekdays_before_first_of_month(arr, date)

          if day_off = DayOff.for_date(date)
            arr.last << day_off
          else
            push_order(arr, date)
          end

          m.append_nils_for_weekdays_after_last_of_month(arr, date)
        end
      end
    end
  end

  def push_order(arr, date)
    order = Order.find_by_student_id_and_served_on(student_id, date)
    order_to_push = order || Order.new(:student_id => student_id, :served_on => date)
    arr.last << Day.new(order_to_push)
  end

  def save
    return false unless orders
    orders.each {|order| create_or_update_order(order)}
  end

  def student_id_from_orders
    orders.first.last['student_id'] if orders
  end

  def create_or_update_order(order_params)
    order_attributes = order_params.last
    if order = existing_order(order_attributes)
      order.update_attributes!(order_attributes)
    elsif order_params_include_menu_items?(order_attributes)
      Order.create!(order_attributes) # if order_attributes['menu_item_ids'].any?
    end
  end

  def existing_order(order_atts)
    student_id = order_atts['student_id']
    served_on = order_atts['served_on']
    Order.find_by_student_id_and_served_on(student_id, served_on)
  end

  def order_params_include_menu_items?(order_attributes)
    order_attributes['menu_item_ids'] &&
      order_attributes['menu_item_ids'].select{ |id| !id.empty? }.any?
  end
end
