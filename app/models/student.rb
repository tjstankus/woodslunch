class Student < ActiveRecord::Base
  GRADES = %w[K 1 2 3 4 5 6 7 8 9 10 11 12]
  ELEMENTARY_SCHOOL_GRADES = %w[K 1 2 3 4]
  MIDDLE_SCHOOL_GRADES = %w[5 6 7 8]
  HIGH_SCHOOL_GRADES = %w[9 10 11 12]

  belongs_to :account
  has_many :orders

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :grade, :presence => true, :inclusion => { :in => GRADES }


  def name
    "#{first_name} #{last_name}"
  end

  def increment_grade
    return true if grade == '12'
    new_grade = case grade
                when 'K'
                  '1'
                else
                  (grade.to_i + 1).to_s
                end
    update_attributes(:grade => new_grade)
  end
end
