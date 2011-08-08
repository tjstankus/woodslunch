module Orderable
  extend ActiveSupport::Concern

  module InstanceMethods

    def start_new_array_for_week?(arr, date)
      !arr.last || date.monday?
    end

    def prepend_nils_for_weekdays_before_first_of_month(arr, date)
      if date == starts_on && !date.monday?
        (date.cwday - 1).times { arr.last << nil }
      end
    end

    def append_nils_for_weekdays_after_last_of_month(arr, date)
      if date == ends_on && !date.friday?
        (5 - date.cwday).times { arr.last << nil }
      end
    end

    # TODO: Is anything really using this? If not get rid of.
    # def first_available_order_date
    #   today = Date.today
    #   if today.wday >= 1 && today.wday <= 5
    #     today.beginning_of_week + 1.week
    #   else
    #     today.beginning_of_week + 2.weeks
    #   end
    # end

  end
end