class Account < ActiveRecord::Base
  has_many :users
  has_many :students

  def change_balance_by(amount)
    self.balance += amount
    self.save
  end
end
