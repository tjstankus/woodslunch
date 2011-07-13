class DaysOffController < InheritedResources::Base
  before_filter :verify_admin

  def create
    create!{ days_off_path }
  end
end
