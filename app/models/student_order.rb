class StudentOrder

  # Presenter
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  def persisted?; false; end;

  attr_accessor :student_id, :year, :month, :orders

  validates :student_id, :presence => true

  def initialize(params)
    @orders = params['orders']
    @student_id = params['student_id'] || student_id_from_orders
    @year = params['year']
    @month = params['month']
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
  def orders_by_weekday
    [].tap do |arr|
      first_date_of_month.upto(last_date_of_month) do |date|

        arr << [] if start_new_array_for_week?(arr, date)

        prepend_nils_for_weekdays_before_first_of_month(arr, date)
        
        push_order(arr, date) if date.weekday?

        append_nils_for_weekdays_after_last_of_month(arr, date)

      end
    end
  end

  def first_date_of_month
    Date.civil(year.to_i, month.to_i, 1)
  end

  def last_date_of_month
    Date.civil(year.to_i, month.to_i, -1)
  end

  def start_new_array_for_week?(arr, date)
    !arr.last || date.monday?
  end

  def prepend_nils_for_weekdays_before_first_of_month(arr, date)
    if date == first_date_of_month && !date.monday?
      (date.cwday - 1).times { arr.last << nil }
    end
  end

  def append_nils_for_weekdays_after_last_of_month(arr, date)
    if date == last_date_of_month && !date.friday?
      (5 - date.cwday).times { arr.last << nil }
    end
  end

  def push_order(arr, date)
    arr.last << Order.new(:student_id => student_id, :served_on => date)
  end

  def save
    return false unless orders
    orders.each {|order| create_order(order)}
  end

  def student_id_from_orders
    orders.first.last['student_id'] if orders
  end

  def create_order(order)
    order_attributes = order.last
    if order_has_selected_menu_items?(order_attributes)
      Order.create!(order_attributes)
    end
  end

  def order_has_selected_menu_items?(order_attributes)
    order_attributes['menu_item_ids'] && 
      order_attributes['menu_item_ids'].select{ |id| !id.empty? }.any?
  end
end
