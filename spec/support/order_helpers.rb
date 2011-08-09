module OrderHelpers

  def create_menu_item_served_on_day(day)
    Factory(:daily_menu_item, :day_of_week => DayOfWeek.find_by_name(day))
  end

  def build_student_order
    StudentOrder.new({'student_id' => Factory(:student).id})
  end

  # def params_to_post_for_single_item_order
  #   {"student_order"=>{ "orders_attributes"=>
  #   {"1"=>{"served_on"=>"2011-08-01", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}, "5"=>{"quantity"=>""}, "6"=>{"quantity"=>""}}},
  #    "2"=>{"served_on"=>"2011-08-02", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "3"=>{"served_on"=>"2011-08-03", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "4"=>{"served_on"=>"2011-08-04", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "5"=>{"served_on"=>"2011-08-05", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>"1"}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "8"=>{"served_on"=>"2011-08-08", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}, "5"=>{"quantity"=>""}, "6"=>{"quantity"=>""}}},
  #    "9"=>{"served_on"=>"2011-08-09", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "10"=>{"served_on"=>"2011-08-10", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "11"=>{"served_on"=>"2011-08-11", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "12"=>{"served_on"=>"2011-08-12", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "15"=>{"served_on"=>"2011-08-15", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}, "5"=>{"quantity"=>""}, "6"=>{"quantity"=>""}}},
  #    "16"=>{"served_on"=>"2011-08-16", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "17"=>{"served_on"=>"2011-08-17", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "18"=>{"served_on"=>"2011-08-18", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "19"=>{"served_on"=>"2011-08-19", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "22"=>{"served_on"=>"2011-08-22", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}, "5"=>{"quantity"=>""}, "6"=>{"quantity"=>""}}},
  #    "23"=>{"served_on"=>"2011-08-23", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "24"=>{"served_on"=>"2011-08-24", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "25"=>{"served_on"=>"2011-08-25", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "26"=>{"served_on"=>"2011-08-26", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}},
  #    "29"=>{"served_on"=>"2011-08-29", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}, "5"=>{"quantity"=>""}, "6"=>{"quantity"=>""}}},
  #    "30"=>{"served_on"=>"2011-08-30", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}, "3"=>{"quantity"=>""}, "4"=>{"quantity"=>""}}},
  #    "31"=>{"served_on"=>"2011-08-31", "ordered_menu_items_attributes"=>{"0"=>{"quantity"=>""}, "1"=>{"quantity"=>""}, "2"=>{"quantity"=>""}}}}}}
  # end

end
