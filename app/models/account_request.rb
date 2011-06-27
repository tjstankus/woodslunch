class AccountRequest < ActiveRecord::Base
  has_many :requested_students, :dependent => :destroy

  validates :email, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  accepts_nested_attributes_for :requested_students

  def full_name
    [first_name, last_name].join(' ')
  end
end
