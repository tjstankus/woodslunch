require 'spec_helper'

describe User do
  it { should belong_to(:account) }
  it { should validate_presence_of(:account_id) }

  describe '#admin?' do
  	context 'given admin role' do
  		it 'returns true' do
        FactoryGirl.build(:admin).has_role?(:admin).should be_true
  		end
  	end

    context 'for non-admin' do
      it 'returns false' do
        FactoryGirl.build(:user).has_role?(:admin).should be_false
      end
    end
  end

  describe '#students' do
    
    let!(:user) { FactoryGirl.create(:user) }
    let(:account) { user.account }

    it 'returns empty array with no students' do
      user.students.should be_empty
    end

    it 'includes associated student' do
      student = FactoryGirl.create(:student, :account => account)
      user.students.should include(student)
    end
  end
end
