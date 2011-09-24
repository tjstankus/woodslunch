class Account < ActiveRecord::Base
  has_many :users
  has_many :students
  has_many :payments

  def change_balance_by(amount)
    self.balance += amount
    self.save
  end

  def self.search(query=nil)
    if query.blank?
      Account.all
    else
      q = "%#{query}%"
      users = User.where('email like ? or first_name like ? or last_name like ?', q, q, q)
      students = Student.where('first_name like ? or last_name like ?', q, q)
      results = users + students
      results.collect(&:account).uniq
    end
  end
end
