require 'spec_helper'

describe OrderedMenuItem do
  it { should belong_to(:menu_item) }
  it { should belong_to(:order) }
  it { should validate_presence_of(:menu_item_id) }
  # it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity) }

  context '::MAX_DISPLAYED_QUANTITY' do
    it 'is an integer' do |variable|
      OrderedMenuItem::MAX_DISPLAYED_QUANTITY.should be_an(Integer)
    end
  end

  describe '#total' do
    it 'defaults to 0' do
      Factory.build(:ordered_menu_item).total.should == 0
    end
  end

  describe '#calculate_total' do
    it 'gets called on save' do
      omi = Factory.build(:ordered_menu_item)
      omi.should_receive(:calculate_total).once
      omi.save
    end
  end

  # describe '#update_order_total_if_total_changed' do
  #   it 'gets called once on save' do
  #     omi = Factory.build(:ordered_menu_item)
  #     omi.should_receive(:update_order_total_if_total_changed).once
  #     omi.save
  #   end

  #   it 'calls order.change_total_by' do
  #     omi = Factory.build(:ordered_menu_item)
  #     omi.order.should_receive(:change_total_by).once.with(omi.menu_item.price)
  #     omi.save
  #   end
  # end

  describe '#total' do
    let(:price) { 4.00 }
    let(:menu_item) { Factory(:menu_item, :price => price) }
    let(:quantity) { 2 }
    let(:ordered_menu_item) {
      Factory(:ordered_menu_item, :menu_item => menu_item, :quantity => quantity)
    }

    it 'calculates menu_item.price * self.quantity' do
      pending 'Account balance work'
      ordered_menu_item.total.should == price * quantity
    end
  end
end
