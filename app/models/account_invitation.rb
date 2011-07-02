class AccountInvitation < ActiveRecord::Base
  belongs_to :account_request

  validates_presence_of :account_request_id
end