class StudentOrder < Order

  belongs_to :student

  validates :student_id, :presence => true

  def self.order_for_date(student_id, date)
    find_by_student_id_and_served_on(student_id, date) ||
    StudentOrder.new(:student_id => student_id, :served_on => date)
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
