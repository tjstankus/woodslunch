class DaysOffController < InheritedResources::Base
  before_filter :verify_admin
end
