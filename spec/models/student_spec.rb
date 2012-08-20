require 'spec_helper'

describe Student do
  it { should belong_to(:account) }
  it { should have_many(:orders) }
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

  describe '#increment_grade' do
    it "changes K to 1" do
      student = Factory.build(:student, :grade => 'K')
      expect {
        student.increment_grade
      }.to change{ student.grade }.to('1')
    end

    it "does not change 12" do
      student = Factory.build(:student, :grade => '12')
      expect {
        student.increment_grade
      }.not_to change{ student.grade }
    end

    it "increments 1 through 11 by 1" do
      (1..11).each do |grade|
        student = Factory.build(:student, :grade => grade.to_s)
        new_grade = grade + 1
        expect {
          student.increment_grade
        }.to change{ student.grade }.to(new_grade.to_s)
      end
    end
  end

end
