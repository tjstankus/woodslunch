require 'spec_helper'

describe Day do

  describe '#date' do

    let(:date) { Date.parse('2011-07-01') }

    it 'returns the initialized date' do
      Day.new(date, double('stub')).date.should == date
    end
  end

  describe '#wrapped_object' do

    let(:date) { Date.today }
    let(:obj) { 'A test string' }
    let(:day) { Day.new(date, obj) }

    it 'returns the initialized wrapped object' do
      day.wrapped_object.should == obj
    end
  end

  describe '#name_for_partial' do
    let(:date) { Date.today }
    let(:obj) { build_student_order }
    let(:day) { Day.new(date, obj) }

    it 'returns the lowercase underscored class name as naming convention for partial' do
      day.name_for_partial.should == 'student_order'
    end
  end

  describe '#month_day' do

    let(:date) { Date.parse('2011-07-01') }

    it 'returns numeric day of month for initialized date' do
      Day.new(date, double('stub')).month_day.should == 1
    end
  end

  describe '#day_name' do

    let(:date) { Date.parse('2011-07-01') }

    it 'returns the day of week name as a string' do
      Day.new(date, double('stub')).day_name.should == 'Friday'
    end
  end
end