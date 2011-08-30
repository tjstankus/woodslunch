class StudentsController < InheritedResources::Base
  belongs_to :account

  before_filter :authenticate_user!
  before_filter :verify_account_member

  def create
    create!(:notice => "A new student has been successfully added to your account.") { account_path(parent) }
  end
end