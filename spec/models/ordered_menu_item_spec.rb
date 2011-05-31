require 'spec_helper'

describe OrderedMenuItem do
  it { should belong_to(:menu_item) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:menu_item_id) }
  it { should validate_presence_of(:order_id) }
end
