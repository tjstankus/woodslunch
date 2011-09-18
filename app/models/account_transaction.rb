class AccountTransaction < ActiveRecord::Base
  belongs_to :account

  validates :account_id, :presence => true
  validates :amount, :presence => true, :numericality => true
end
