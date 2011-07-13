require 'spec_helper'

describe DayOff do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:starts_on) }
  it { should validate_presence_of(:ends_on) }

  it 'validates that starts_on <= ends_on' do
    day_off = Factory.build(:day_off, :starts_on => '2011-09-09', :ends_on => '2011-09-08')
    day_off.should_not be_valid
    day_off.errors[:base].should_not be_empty
  end
end
