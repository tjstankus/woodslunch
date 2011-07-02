require 'spec_helper'

describe OrderedMenuItem do
  it { should belong_to(:menu_item) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:menu_item_id) }
  it { should validate_presence_of(:order_id) }
  # TODO: add quantity and validate its presence
  # it { should validate_presence_of(:quantity) }
  # it { should validate_numericality_of(:quantity) }

  context '::MAX_DISPLAYED_QUANTITY' do
    it 'is an integer' do |variable|
      pending
      OrderedMenuItem::MAX_DISPLAYED_QUANTITY.should be_an(Integer)
    end
  end
end
