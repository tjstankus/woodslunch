require 'spec_helper'

describe 'Menu items' do

  let!(:daily_menu_item) { Factory(:daily_menu_item) }
  let(:menu_item) { daily_menu_item.menu_item }

  before(:each) do
    @admin = Factory(:admin)
    sign_in_as(@admin)
  end

  describe 'GET index listing' do

    context 'when logged in as an admin' do
      it 'displays menu items' do
        visit menu_items_path
        page.should have_content(menu_item.name)
      end
    end

    context 'when logged in as a regular user' do
      before(:each) do
        sign_out
        @user = Factory(:user)
        sign_in_as(@user)
      end

      it 'redirects to the home page' do
        visit menu_items_path
        current_path.should == root_path
      end
    end
  end

  describe 'GET new' do

    before(:each) do
      # When I go to the new menu item page
      visit new_menu_item_path
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
      visit new_menu_item_path
    end

    it 'creates a menu item' do
      # When I fill in Name with "Tacos"
      fill_in 'Name', :with => 'Tacos'

      # And I check "Monday" for "Served on"
      check 'Monday'

      # And I press submit
      click_button 'menu_item_submit'

      # Then I should see the menu item listed under Monday
      page.should have_xpath("//div[@id='monday']" +
        "//span[@class='menu_item_name']", :text => 'Tacos')
    end

    it 'creates a menu item with multiple served on days' do
      # When I fill in name with "Chicken fajitas"
      fill_in 'Name', :with => 'Chicken fajitas'

      # And I check "Monday" for "Days served on"
      check 'Monday'

      # And I check "Thursday" for "Days served on"
      check 'Thursday'

      # And I press submit
      click_button 'menu_item_submit'

      # Then I should see the menu item listed under Monday
      page.should have_xpath("//div[@id='monday']" +
        "//span[@class='menu_item_name']", :text => 'Chicken fajitas')

      # And I should see the menu item listed under Thursday
      page.should have_xpath("//div[@id='thursday']" +
        "//span[@class='menu_item_name']", :text => 'Chicken fajitas')
    end

    context 'without a served on day' do
      it 'displays a menu item as unassigned to a day' do
        # When I fill in Name with "Tacos"
        fill_in 'Name', :with => 'Tacos'

        # And I press submit
        click_button 'menu_item_submit'

        # Then I should see the menu item listed as unassigned to a day
        page.should have_xpath("//div[contains(@class, 'unassigned')]//a[text()='Tacos']")
      end
    end

    context 'given invalid data' do
      it 'displays error message' do
        # When I leave name blank
        fill_in 'Name', :with => ''

        # And I press submit
        click_button 'menu_item_submit'

        # Then I should see an error notification
        page.should have_xpath("//*[@class='error_notification']")
      end
    end
  end

  describe 'PUT update' do

    it 'changes name of menu item' do
      # Given a daily menu item

      # When I go to the edit menu item page
      visit edit_menu_item_path(menu_item)

      # And I change the menu item name to "Banana split"
      fill_in 'menu_item_name', :with => 'Banana split'

      # And I press submit
      click_button 'menu_item_submit'

      # Then I should see a menu item named "Banana split"
      page.should have_xpath("//span[@class='menu_item_name']",
                             :text => 'Banana split')
    end

    it 'removes one of two served on days for a menu item' do
      # Given a menu item served on Monday and Tuesday
      daily_menu_item.day_of_week.name.should == 'Monday'
      tuesday = DayOfWeek.find_by_name('Tuesday')
      Factory(:daily_menu_item, :menu_item => menu_item,
        :day_of_week => tuesday)

      # When I go to the edit menu item page
      visit edit_menu_item_path(menu_item)

      # And I uncheck Monday
      uncheck 'Monday'

      # And I press submit
      click_button 'menu_item_submit'

      # Then the menu item should not be listed under Monday
      page.should have_no_xpath("//div[@id='monday']" +
        "//span[@class='menu_item_name']", :text => menu_item.name)

      page.should_not have_xpath("//div[@id='monday']//a[text()='#{menu_item.name}']")

      # And the menu item should be listed under Tuesday
      page.should have_xpath("//div[@id='tuesday']" +
        "//span[@class='menu_item_name']", :text => menu_item.name)
    end
  end


  describe 'DELETE destroy' do

    before(:each) do
      # Given a daily menu item

      # When I go to the edit menu item page
      visit edit_menu_item_path(menu_item)
    end

    it 'redirects to index' do
      # And I click the 'Delete' link
      click_link 'Delete'

      # Then I should be back on the admin menu items index page
      current_path.should == menu_items_path
    end

    it 'displays flash notice' do
      name = menu_item.name

      # And I click the 'Delete' link
      click_link 'Delete'

      # Then I should see a flash message displayed
      page.should have_xpath("//div[@id='notice']",
                             :text => "Successfully deleted #{name}.")
    end

    it 'destroys record' do
      # And I click the 'Delete' link
      # Then the menu item should be destroyed
      lambda {
        click_link 'Delete'
      }.should change{ MenuItem.count }.by(-1)
    end

  end
end
