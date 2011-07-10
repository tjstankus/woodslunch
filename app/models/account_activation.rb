class AccountActivation

  # Presenter
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  def persisted?; false; end;

  attr_accessor :account_request_id

  validates :account_request_id, :presence => true

  def initialize(params)
    @account_request_id = params['account_request_id']
  end

end