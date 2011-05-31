require 'spec_helper'

describe Order do
  it { should belong_to(:student) }
  it { should have_many(:menu_items).through(:ordered_menu_items) }

  it { should validate_presence_of(:served_on) }
  it { should validate_presence_of(:student_id) }
end
