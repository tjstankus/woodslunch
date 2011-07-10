class AccountActivation

  # Presenter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  def persisted?; false; end;

  attr_accessor :account_request_id, :password, :password_confirmation

  validates :account_request_id, :presence => true

  def initialize(params)
    @account_request_id = params['account_request_id']
    @password = params['password']
    @password_confirmation = params['password_confirmation']
  end

  def account_request
    @account_request ||= AccountRequest.find(@account_request_id)
  end

  def email
    @email ||= account_request.email
  end

  def account
    @account ||= Account.create
  end

  def save
    # TODO: Must return true or false
    # TODO: Add to error unless password == password_confirmation
    # TODO: account_request must be approved
    User.create(:account_id => account.id, :email => email, :password => password,
        :first_name => account_request.first_name,
        :last_name => account_request.last_name)
    account_request.requested_students.each do |student|
      Student.create(:account_id => account.id,
          :first_name => student.first_name, :last_name => student.last_name,
          :grade => student.grade)
    end
  end
end