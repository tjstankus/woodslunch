require 'spec_helper'

describe DayOfWeek do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should have_many(:daily_menu_items) }
  it { should have_many(:menu_items).through(:daily_menu_items) }

  describe '#name=' do
    it 'should accept valid names of days' do
      DayOfWeek.destroy_all
      DayOfWeek::NAMES.each do |day_name|
        lambda {
          DayOfWeek.create!(:name => day_name)
        }.should_not raise_error
      end
    end

    it 'should not accept invalid names of days' do
      lambda {
        DayOfWeek.create!(:name => 'Invalid')
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.weekdays' do
    it 'should include all weekdays' do
      %w(Monday Tuesday Wednesday Thursday Friday).each do |weekday|
        DayOfWeek.weekdays.collect(&:name).should include(weekday)
      end
    end

    it 'should not include weekend days' do
      %w(Saturday Sunday).each do |weekend_day|
        DayOfWeek.weekdays.collect(&:name).should_not include(weekend_day)
      end
    end
  end
end