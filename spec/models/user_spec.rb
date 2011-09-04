require 'spec_helper'

describe User do
  it { should belong_to(:account) }
  it { should have_many(:orders) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:account_id) }

  describe '#email' do

    context 'given a persisted record' do

      before(:all) do
        User.destroy_all
        Factory(:user)
      end

      it { should validate_uniqueness_of(:email).case_insensitive }

    end

  end

  describe '#has_role?' do
    context 'admin' do
      context 'given admin role' do
        it 'returns true' do
          Factory.build(:admin).has_role?(:admin).should be_true
        end
      end

      context 'for non-admin' do
        it 'returns false' do
          Factory.build(:user).has_role?(:admin).should be_false
        end
      end
    end
  end

  describe '#students' do

    let!(:user) { Factory(:user) }
    let(:account) { user.account }

    it 'returns empty array with no students' do
      user.students.should be_empty
    end

    it 'includes associated student' do
      student = Factory(:student, :account => account)
      user.students.should include(student)
    end
  end
end
