require 'spec_helper'

describe MonthHelper do

  describe '#month' do
    context 'when initialized with number' do
      it 'returns numeric month' do
        MonthHelper.new(5, 2011).month.should == 5
      end
    end

    context 'when initialized with string' do
      it 'returns numeric month' do
        MonthHelper.new('5', 2011).month.should == 5
      end
    end
  end

  describe '#year' do
    context 'when initialized with number' do
      it 'returns numeric year' do
        MonthHelper.new(5, 2011).year.should == 2011
      end
    end

    context 'when initialized with string' do
      it 'returns numeric year' do
        MonthHelper.new(5, '2011').year.should == 2011
      end
    end
  end

  describe '#weekdays_grouped_by_week' do
    context 'given a month where first weekday is a Friday' do

      let(:presenter) { presenter = MonthHelper.new(7, 2011) }

      it 'returns nils in first week' do
        first_week = presenter.weekdays_grouped_by_week.first
        (0..3).each do |i|
          first_week[i].should be_nil
        end
      end
    end
  end

  describe '#day' do
    describe '#month_day' do
      it 'returns numeric day of month' do
        presenter = MonthHelper.new(7, 2011)
        day = presenter.weekdays_grouped_by_week.first.last
        day.month_day.should == 1
      end
    end
  end

  describe '#first_date_of_month' do

    let(:month) { 4 }
    let(:year) { 2011 }
    let(:presenter) { MonthHelper.new(month, year) }

    it 'returns a Date object for the first day of the month' do
      expected_date = Date.civil(year.to_i, month.to_i, 1)
      presenter.first_date.should == expected_date
    end
  end
end