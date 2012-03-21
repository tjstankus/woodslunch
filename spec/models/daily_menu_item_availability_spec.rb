require 'spec_helper'

describe DailyMenuItemAvailability do
  it { should belong_to(:daily_menu_item) }
  it { should validate_presence_of(:daily_menu_item_id) }
  it { should validate_presence_of(:starts_on) }

  it 'initializes unavailable to false' do
    Factory.build(:daily_menu_item_availability).available.should be_false
  end

  it 'creates a valid object via factory' do
    Factory.build(:daily_menu_item_availability).should be_valid
  end

  describe '#available_on_date?' do

    context 'given false availability' do

      before(:each) do
        @dmia = Factory.build(:daily_menu_item_availability, :starts_on => 2.days.ago.to_date)
      end

      it 'is unavailable after the starts on date' do
        @dmia.available_on_date?(Date.today).should be_false
      end

      it 'is available before the starts on date' do
        @dmia.available_on_date?(5.days.ago.to_date).should be_true
      end
    end

    context 'given true availability' do

      before(:each) do
        @dmia = Factory.build(:daily_menu_item_availability,
                              :starts_on => 2.days.ago.to_date,
                              :available => true)
      end

      it 'is unavailable before the starts on date' do
        @dmia.available_on_date?(@dmia.starts_on - 3.days).should be_false
      end

      it 'is available after the starts on date' do
        @dmia.available_on_date?(@dmia.starts_on + 3.days).should be_true
      end
    end

    it 'raises error when ends_on is not blank' do
      dmia = Factory.build(:daily_menu_item_availability,
                           :starts_on => 1.week.ago.to_date,
                           :ends_on => 1.month.from_now.to_date)
      lambda {
        dmia.available_on_date?(Date.today)
      }.should raise_error(NotImplementedError)
    end
  end

end