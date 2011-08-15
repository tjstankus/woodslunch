class User < ActiveRecord::Base

  include RoleModel
  roles :admin

  belongs_to :account

  validates :email, :presence => true,
      :uniqueness => { :case_sensitive => false }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :account_id, :presence => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :registerable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
      :first_name, :last_name, :account_id

  def name
    "#{first_name} #{last_name}"
  end

  def students
    self.account.students
  end
end
