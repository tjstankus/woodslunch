class Student < ActiveRecord::Base
  GRADES = %w[K 1 2 3 4 5 6 7 8 9 10 11 12]

  belongs_to :account
  has_many :student_orders

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :grade, :presence => true, :inclusion => { :in => GRADES }


  def name
    "#{first_name} #{last_name}"
  end

  def student_order_for_date(date)
    student_orders.where(":date >= starts_on AND :date <= ends_on", {:date => date.to_s}).first
  end

end
