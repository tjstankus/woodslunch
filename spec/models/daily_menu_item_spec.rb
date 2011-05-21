require 'spec_helper'

describe DailyMenuItem do
  it { should validate_presence_of(:menu_item_id) }
  it { should validate_presence_of(:day_of_week_id) }
end
