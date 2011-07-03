class AccountInvitation < ActiveRecord::Base
  belongs_to :account_request

  validates_presence_of :account_request_id

  after_create :deliver_email

  def deliver_email
    AccountInvitationMailer.invitation(account_request).deliver
  end
end