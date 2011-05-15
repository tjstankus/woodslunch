require 'spec_helper'

feature 'Managing menu items' do

  let!(:menu_item) { FactoryGirl.create(:menu_item) }

  context 'when logged in as an admin' do
    let(:admin) { FactoryGirl.create(:admin) }

    before(:each) do
      sign_in_as(admin)   
    end

    context 'GET /admin/menu_items' do
      scenario 'displays menu items' do
        visit admin_menu_items_path 
        page.should have_content(menu_item.name)
      end	
    end
  end

  context 'when logged in as a regular user' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
    	sign_in_as(user)
    end

    context 'GET /admin/menu_items' do
      it 'should redirect to the home page' do
				visit admin_menu_items_path
				current_path.should == root_path
      end
    end
  end
end
