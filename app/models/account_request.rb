class AccountRequest < ActiveRecord::Base
  has_many :requested_students

  validates :email, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  accepts_nested_attributes_for :requested_students
end
