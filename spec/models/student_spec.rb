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
      FactoryGirl.build(:student, :grade => grade).should be_valid
    end

    invalid_grades = %w(foo bar 0 13)
    invalid_grades.each do |invalid_grade|
      FactoryGirl.build(:student, :grade => invalid_grade).
        should_not be_valid
    end
  end

  describe '#name' do
    it 'returns first and last name' do
      student = FactoryGirl.build(:student, 
                                  :first_name => 'Jane', 
                                  :last_name => 'Doe')
      student.name.should == 'Jane Doe'
    end
  end
end
