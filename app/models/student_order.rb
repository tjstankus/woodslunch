class StudentOrder < Order

  belongs_to :student

  validates :student_id, :presence => true

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

  def self.create_or_update_via_params(params)
    params.values.each do |atts|
      order_id = atts.delete(:id)
      if order_id.blank?
        StudentOrder.create!(atts) if create_student_order?(atts[:ordered_menu_items_attributes])
      else
        StudentOrder.find(order_id).update_attributes!(atts)
      end
    end
  end

  def self.create_student_order?(ordered_menu_items_attributes)
    atts = ordered_menu_items_attributes.values
    !(atts.collect{|h| h['quantity']}.all?{|q| q.empty?})
  end

end
