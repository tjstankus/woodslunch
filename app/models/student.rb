class Student < ActiveRecord::Base
  VALID_GRADES = %w[K 1 2 3 4 5 6 7 8 9 10 11 12]

  belongs_to :user

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :grade, :presence => true, :inclusion => { :in => Student::VALID_GRADES }


  def name
    "#{first_name} #{last_name}"
  end
end
