class AccountRequest < ActiveRecord::Base
  has_many :requested_students, :dependent => :destroy
  has_one :account_invitation

  validates :email, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  before_validation :set_activation_token

  accepts_nested_attributes_for :requested_students

  state_machine :state, :initial => :pending do

    after_transition :on => :approve, :do => :approve_actions

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

  def approve_actions
    approve_now
    create_invitation
  end

  def approve_now
    update_attribute(:approved_at, Time.now)
  end

  def create_invitation
    create_account_invitation
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def set_activation_token
    self.activation_token ||= SecureRandom.hex(16)
  end
end
