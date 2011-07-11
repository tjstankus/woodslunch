class AccountRequest < ActiveRecord::Base
  has_many :requested_students, :dependent => :destroy

  validates :email, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  accepts_nested_attributes_for :requested_students

  state_machine :state, :initial => :pending do

    after_transition :on => :approve, :do => :approve_actions

    # TODO: Spec and implement
    # after_transition :on => :decline, :do => :decline_actions

    after_transition :on => :activate do |account_request, transition|
      account_request.destroy
    end

    event :approve do
      transition [:pending] => :approved
    end

    # TODO: Spec and implement
    # event :decline do
    #   transition [:pending] => :declined
    # end

    event :activate do
      transition [:approved] => :activated
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
    set_activation_token
    deliver_activation_email
  end

  def approve_now
    update_attribute(:approved_at, Time.now)
  end

  def deliver_activation_email
    AccountMailer.activation(self).deliver
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def set_activation_token
    self.activation_token ||= SecureRandom.hex(16)
    self.save!
  end
end
