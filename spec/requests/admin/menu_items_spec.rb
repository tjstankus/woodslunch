require 'spec_helper'

describe 'Managing menu items' do

  let!(:menu_item) { FactoryGirl.create(:menu_item) }
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:user) { FactoryGirl.create(:user) }

  describe 'index listing' do

    context 'when logged in as an admin' do
      before(:each) do
        sign_in_as(admin)   
      end

      it 'displays menu items' do
        visit admin_menu_items_path 
        page.should have_content(menu_item.name)
      end	
    end  

    context 'when logged in as a regular user' do
      before(:each) do
        sign_in_as(user)
      end

      it 'should redirect to the home page' do
        visit admin_menu_items_path
        current_path.should == root_path
      end
    end
  end

  describe 'new menu item' do
    before(:each) do
      sign_in_as(admin)

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

  describe 'create menu item' do

    end
  end
