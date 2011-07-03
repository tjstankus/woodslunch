class AccountInvitation < ActiveRecord::Base
  belongs_to :account_request

  validates_presence_of :account_request_id

  before_validation :set_token
  after_create :deliver_email

  def set_token
    self.token = SecureRandom.hex(16) unless self.token
  end

  def deliver_email
    AccountInvitationMailer.invitation(self).deliver
  end
end