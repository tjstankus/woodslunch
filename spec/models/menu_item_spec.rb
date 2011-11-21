require 'spec_helper'

describe MenuItem do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).with_message(/must be a number/) }
  it { should have_many(:daily_menu_items) }
  it { should have_many(:days_of_week).through(:daily_menu_items) }

  context 'given a saved menu item' do
    let!(:menu_item) { Factory(:menu_item) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  it 'sets default price attribute on new record' do
    MenuItem.new.price.should == MenuItem::DEFAULT_PRICE
  end

  it 'builds a valid factory' do
    Factory.build(:menu_item).should be_valid
  end

  describe '.unassigned_to_day' do
    
    context 'given menu item records with no days of week assigned' do
      
      before(:each) do
        @menu_items = [].tap do |a| 
          3.times do |i|
            a << Factory(:menu_item, :name => "Food Item #{i}")
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

  describe '#destroy' do

    let!(:daily_menu_item) { Factory(:daily_menu_item) }
    let!(:menu_item) { daily_menu_item.menu_item }
    
    it 'removes record from database' do
      id = menu_item.id
      menu_item.destroy
      lambda {
        MenuItem.find(id)
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it 'destroys associated daily_menu_items' do
      menu_item.daily_menu_items.should include(daily_menu_item)
      id = daily_menu_item.id
      menu_item.destroy
      lambda {
        DailyMenuItem.find(id)
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#inactive_on_date?' do
    let(:menu_item) { Factory.build(:menu_item) }

    context 'given inactive_starts_on is nil' do
      it 'returns false' do
        menu_item.inactive_starts_on = nil
        menu_item.inactive_on_date?(Date.today).should be_false
      end
    end

    context 'given inactive_starts_on is set to a future date' do
      it 'returns false' do
        menu_item.inactive_starts_on = 3.days.from_now
        menu_item.inactive_on_date?(Date.today).should be_false
      end
    end

    context 'given inactive_starts_on is set to today' do
      it 'returns true' do
        menu_item.inactive_starts_on = Date.today
        menu_item.inactive_on_date?(Date.today).should be_true
      end
    end

    context 'given inactive_starts_on is set to a past date' do
      it 'returns true' do
        menu_item.inactive_starts_on = 3.days.ago
        menu_item.inactive_on_date?(Date.today).should be_true
      end
    end
  end
end
