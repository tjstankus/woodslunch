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

  describe '.unassigned_to_day' do
    
    context 'given menu item records with no days of week assigned' do
      
      before(:each) do
        @menu_items = [].tap do |a| 
          3.times do |i|
            a << FactoryGirl.create(:menu_item, :name => "Food Item #{i}")
          end
        end
      end

      it 'have empty #days_of_week collections' do
        @menu_items.each { |menu_item| menu_item.days_of_week.should be_empty }
      end

      it 'returns those menu items' do
        unassigned = MenuItem.unassigned_to_day
        @menu_items.each do |menu_item|
          unassigned.should include(menu_item)
        end
        unassigned.size.should == @menu_items.size 
      end
    end
  end
end
