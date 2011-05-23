require 'spec_helper'

describe 'Menu items' do

  let!(:daily_menu_item) { FactoryGirl.create(:daily_menu_item) }
  let(:menu_item) { daily_menu_item.menu_item }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in_as(admin)
  end

  describe 'GET index listing' do

    context 'when logged in as an admin' do
      it 'displays menu items' do
        visit admin_menu_items_path 
        page.should have_content(menu_item.name)
      end	
    end  

    context 'when logged in as a regular user' do
      before(:each) do
        sign_out
        sign_in_as(user)
      end

      it 'should redirect to the home page' do
        visit admin_menu_items_path
        current_path.should == root_path
      end
    end
  end

  describe 'GET new' do

    before(:each) do
      # When I go to the new menu item page
      visit new_admin_menu_item_path
    end

    it 'prefills price field with default price presented as text/string ' do
      # Then the price field should be filled in
      page.should have_selector(:xpath, 
          "//input[@type='text']" + 
          "[@id='menu_item_price']" + 
          "[@value='4.00']")
    end

    it 'denotes required fields' do
      # Then name should be a required field
      # And price should be a required field
      %w(name price).each do |attr|
        page.should have_xpath("//label[@for='menu_item_#{attr}'][contains(@class, 'required')]")
      end
    end

    it 'displays weekdays' do
      DayOfWeek.weekdays.each do |day|
        page.should have_content(day.name)
      end
    end
  end

  describe 'POST create' do

    before(:each) do
      # When I go to the new menu item page
      visit new_admin_menu_item_path
    end

    it 'creates menu item' do
      # When I fill in Name with "Tacos"
      fill_in 'Name', :with => 'Tacos'

      # And I check "Monday" for "Served on"
      check 'Monday'

      # And I press submit
      click_button 'menu_item_submit'

      # Then I should see the menu item listed under Monday
      page.should have_xpath("//div[@id='monday']//a[text()='Tacos']")
    end

    context 'without a served on day' do
      it 'displays menu item as unassigned to a day' do
        # When I fill in Name with "Tacos"
        fill_in 'Name', :with => 'Tacos'

        # And I press submit
        click_button 'menu_item_submit'

        # Then I should see the menu item listed as unassigned to a day
        page.should have_xpath("//div[contains(@class, 'unassigned')]//a[text()='Tacos']")
      end
    end
  end

  describe 'PUT update' do

    it 'changes name of menu item' do
      # Given a daily menu item

      # When I go to the edit menu item page
      visit edit_admin_menu_item_path(menu_item)

      # And I change the menu item name to "Banana split"
      fill_in 'menu_item_name', :with => 'Banana split'

      # And I press submit
      click_button 'menu_item_submit'

      # Then I should see a menu item named "Banana split"
      page.should have_xpath("//a[text()='Banana split']")
    end
  end
end
