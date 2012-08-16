require 'spec_helper'

describe 'Accounts' do
  include ActionView::Helpers::NumberHelper

  describe 'GET index' do

    # Given there is an account with a user
    let!(:user) { Factory(:user) }
    let!(:admin) { Factory(:admin) }

    # And I am logged in as an admin
    before(:each) do
      sign_in_as(admin)
    end

    it 'displays account information' do

      # When I go to the accounts index page
      visit accounts_path

      # Then I should see that account
      page.should have_css("#account_#{user.account.id}")
    end

  end

  describe 'balance' do

    before(:each) do
      @account = Factory(:account)
      @user = Factory(:user, :account => @account)
    end

    context 'given an account with students' do

      before(:each) do
        @student = Factory(:student, :account => @account)
      end

      it 'displays on dashboard' do
        # Given I am signed in
        sign_in_as(@user)

        # When I visit the home page
        current_path.should == root_path

        # Then I should see my account balance
        page.should have_css('#balance')
      end
    end

    it 'updates with lunch order' do
      pending 'Account balance work'
      # Given I am a signed in user with a student
      account = Factory(:account)
      user = Factory(:user, :account => account)
      student = Factory(:student, :account => account)
      sign_in_as(user)

      # When I go to the lunch order form
      daily_menu_item = create_menu_item_served_on_day('Monday')
      menu_item = daily_menu_item.menu_item
      path_params = {:year => '2011', :month => '5'}
      visit new_student_order_path(student, path_params)

      # And I place a lunch order for one item
      within('.monday') do
        within('div[data-index="0"]') do
          select '1'
        end
      end

      click_button 'Place Order'

      # Then I should see my account balance as the cost of the item
      page.should have_xpath("//div[@id='balance']",
          :text => number_to_currency(menu_item.price))
    end

  end

  describe 'GET with_balances' do
    let(:user) { Factory(:user) }
    let!(:account) { user.account }
    let!(:admin) { Factory(:admin) }

    context 'given an account with a balance > 0' do
      before(:each) do
        set_account_balance(account, 10)
      end

      it 'displays account balance' do
        signed_in_as(admin) do
          visit with_balances_accounts_path
          page.should have_content('$10.00')
        end
      end

      it 'displays account user email' do
        signed_in_as(admin) do
          visit with_balances_accounts_path
          page.should have_content(user.email)
        end
      end
    end
  end
end
