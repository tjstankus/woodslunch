require 'spec_helper'

describe 'Accounts' do
  include ActionView::Helpers::NumberHelper

  it 'displays balance on home page' do
    pending
    
    # Given I am signed in
    user = FactoryGirl.create(:user)
    sign_in_as(user)

    # When I visit the home page
    current_path.should == root_path

    # TODO: Then I should see my account balance
  end

  describe 'balance' do
    
    it 'updates with lunch order' do
      # Given I am a signed in user with a student
      student = FactoryGirl.create(:student)
      user = student.user
      sign_in_as(user)

      # And I have an account
      account = FactoryGirl.create(:account)
      account.users << user
      account.save!

      # When I go to the lunch order form
      daily_menu_item = create_menu_item_served_on_day('Monday')
      menu_item = daily_menu_item.menu_item
      path_params = {:year => '2011', :month => '5'}
      visit edit_student_order_path(student, path_params)

      # And I place a lunch order for one item
      check menu_item.name
      click_button 'Place Order'

      # Then I should see my account balance as the cost of the item
      page.should have_xpath("//div[@id='balance']", 
          :text => number_to_currency(menu_item.price))
    end
  end

end
