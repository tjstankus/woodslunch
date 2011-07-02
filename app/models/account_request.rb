class AccountRequest < ActiveRecord::Base
  has_many :requested_students, :dependent => :destroy
  has_one :account_invitation

  validates :email, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  accepts_nested_attributes_for :requested_students

  state_machine :state, :initial => :pending do
    event :approve do
      transition [:pending] => :approved
    end
  end

  def self.pending
    where("state = 'pending'")
  end

  def self.approved
    where("state = 'approved'")
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
