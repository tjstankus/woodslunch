require 'spec_helper'

describe Student do
  it { should belong_to(:account) }
  it { should have_many(:student_orders) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:grade) }

  it 'ensures grade has proper value' do

    valid_grades = %w(K 1 2 3 4 5 6 7 8 9 10 11 12)
    valid_grades.each do |grade|
      Factory.build(:student, :grade => grade).should be_valid
    end

    invalid_grades = %w(foo bar 0 13)
    invalid_grades.each do |invalid_grade|
      Factory.build(:student, :grade => invalid_grade).
        should_not be_valid
    end
  end

  describe '#name' do
    it 'returns first and last name' do
      student = Factory.build(:student, :first_name => 'Jane',
          :last_name => 'Doe')
      student.name.should == 'Jane Doe'
    end
  end

  describe '#student_order_for_date' do

    let!(:student) { Factory(:student) }

    context 'given a student order for the requested date' do

      let!(:student_order) do
        Factory(:student_order,
                :student => student,
                :starts_on => '2011-09-01',
                :ends_on => '2011-09-30')
      end

      it 'returns true' do
        student.student_order_for_date(Date.parse('2011-09-20')).should == student_order
      end
    end

    context 'given no student order for the requested date' do

      it 'returns false' do
        # sanity check
        student.student_orders.should be_empty

        student.student_order_for_date(Date.parse('2011-09-20')).should be_nil
      end
    end
  end
end
