class Account < ActiveRecord::Base
  has_many :users

  def change_balance_by(amount)
    self.balance += amount
    self.save
  end
end
