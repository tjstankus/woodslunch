require 'spec_helper'

feature 'home page' do

  context 'given a logged in user' do

    before(:each) do
      @user = Factory(:user)
      sign_in_as(@user)
    end

    it 'displays a logged in message' do
      page.should have_xpath("//div[@id='notice']", :text => 'Signed in successfully.')
    end

    it 'displays user account info' do
      page.should have_xpath("//span[@id='signed_in_as']", :text => @user.email)
    end

  end

  context 'for public browsing' do

    before(:each) do
      # Given I am not logged in
      # When I go to the home page
      visit root_path
    end

    it 'displays a link to the sign in page' do
      page.should have_xpath("//a[contains(@href, '/users/sign_in')]")
    end

    it 'displays a link to the account request page' do
      page.should have_xpath("//a[@href=\"#{new_account_request_path}\"]")
    end

  end

end
