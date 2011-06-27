class RequestedStudent < ActiveRecord::Base
  belongs_to :account_request

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :grade, :presence => true, :inclusion => { :in => Student::GRADES }

  def full_name
    [first_name, last_name].join(' ')
  end

end
