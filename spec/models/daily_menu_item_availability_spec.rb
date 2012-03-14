require 'spec_helper'

describe DailyMenuItemAvailability do
  it { should belong_to(:daily_menu_item) }
  it { should validate_presence_of(:daily_menu_item_id) }
  it { should validate_presence_of(:starts_on) }
  it { should validate_presence_of(:available) }
end