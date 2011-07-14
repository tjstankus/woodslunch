require 'spec_helper'

describe DayOff do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:starts_on) }
  it { should validate_presence_of(:ends_on) }

  context 'given a saved day off' do
    let!(:day_off) { Factory(:day_off) }
    it { should validate_uniqueness_of(:starts_on) }
    it { should validate_uniqueness_of(:ends_on) }
  end

  it 'validates that starts_on <= ends_on' do
    day_off = Factory.build(:day_off, :starts_on => '2011-09-09', :ends_on => '2011-09-08')
    day_off.should_not be_valid
    day_off.errors[:base].should_not be_empty
  end

  describe '.for_date' do
    it 'returns DayOff object for date that is a day off' do
      day_off = Factory(:day_off)
      DayOff.for_date(day_off.starts_on).should == day_off
    end

    it 'returns nil for date that is not a day off' do
      d = Date.parse('2010-08-24')
      DayOff.for_date(d).should be_nil
    end
  end
end
