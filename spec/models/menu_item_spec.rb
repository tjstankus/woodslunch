require 'spec_helper'

describe MenuItem do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).with_message(/must be a number/) }
  it { should have_many(:daily_menu_items) }
  it { should have_many(:days_of_week).through(:daily_menu_items) }

  context 'given a saved menu item' do
    let!(:menu_item) { FactoryGirl.create(:menu_item) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  it 'sets default price attribute on new record' do
    MenuItem.new.price.should == MenuItem::DEFAULT_PRICE
  end

  it 'builds a valid factory' do
    FactoryGirl.build(:menu_item).should be_valid
  end
end