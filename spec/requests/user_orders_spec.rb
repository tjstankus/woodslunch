require 'spec_helper'

describe 'User orders' do

  # Setup an account with a user and associated student
  let!(:account) { Factory(:account) }
  let!(:user) { Factory(:user, :account => account) }
  let(:year) { '2011' }
  let(:month) { '9' }

  before(:each) do
    # Given I am signed in
    sign_in_as(user)
  end

  describe 'when not signed in' do

    before(:each) do
      # Given I am not signed in
      sign_out
    end

    describe 'GET form' do

      it 'redirects to sign in page' do
        # When I visit the new student order page
        visit user_orders_path(user, :year => year, :month => month)

        # Then I should be redirected to the login page
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET form' do

    it 'displays the user name' do
      visit user_orders_path(user, :year => year, :month => month)
      page.should have_content(user.name)
    end
  end
end