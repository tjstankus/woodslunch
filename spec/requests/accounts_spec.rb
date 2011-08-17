require 'spec_helper'

describe 'Accounts' do
  include ActionView::Helpers::NumberHelper

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
        page.should have_xpath("//div[@id='balance']")
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
end
