require 'spec_helper'

describe Account do
  it { should have_many(:users) }
  it { should have_many(:students) }
  it { should have_many(:payments) }

  describe '#change_balance_by' do
    
    it 'updates balance and saves' do
      account = Factory.build(:account)
      account.change_balance_by(1)
      account.reload.balance.should == 1
    end
  end

  describe '.search' do
    it 'should not be case sensitive' do
      user = Factory(:user, :first_name => 'Marge', :last_name => 'Simpson')
      Account.search('marge').should include(user.account)
    end

    context 'given no query' do
      it 'returns all accounts' do
        Account.should_receive(:all)
        Account.search
      end
    end

    context 'querying users' do
      context 'by last name' do
        it "includes the user's account in results" do
          user = Factory(:user)
          Account.search(user.last_name).should include(user.account)
        end
      end

      context 'by first name' do
        it "includes the user's account in results" do
          user = Factory(:user)
          Account.search(user.first_name).should include(user.account)
        end
      end

      context 'by email' do
        it "includes the user's account in results" do
          user = Factory(:user)
          Account.search(user.email).should include(user.account)
        end
      end
    end

    context 'querying students' do
      context 'by last name' do
        it "includes the student's account in results" do
          student = Factory(:student)
          Account.search(student.last_name).should include(student.account)
        end
      end

      context 'by first name' do
        it "includes the student's account in results" do
          student = Factory(:student)
          Account.search(student.first_name).should include(student.account)
        end
      end
    end
  end
end
