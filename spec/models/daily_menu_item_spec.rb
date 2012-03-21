require 'spec_helper'

describe DailyMenuItem do
  it { should validate_presence_of(:menu_item_id) }
  it { should validate_presence_of(:day_of_week_id) }
  it { should have_many(:availabilities).class_name('DailyMenuItemAvailability') }

  it 'has no associated availabilities by default' do
    dmi = Factory.build(:daily_menu_item)
    dmi.availabilities.should be_empty
  end

  describe '#available_on_date?' do

    context 'given no associated availablilites' do

      let(:dmi) { Factory.build(:daily_menu_item) }

      it 'returns true' do
        dmi.available_on_date?(Date.today).should be_true
      end

    end

    context 'given associated availabilities' do

      let!(:dmia) { Factory(:daily_menu_item_availability) }
      let!(:dmi) { dmia.daily_menu_item }

      it 'forwards to the first associated availability' do
        date = Date.today
        DailyMenuItemAvailability.any_instance.should_receive(:available_on_date?).with(date)
        dmi.available_on_date?(date)
      end
    end

  end
end
