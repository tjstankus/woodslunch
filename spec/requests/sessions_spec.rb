require 'spec_helper'

feature 'sessions' do

  let(:user) { Factory(:user) }
  
  scenario 'signing in' do
    sign_in_as(user)
  end

  scenario 'signing out' do
    sign_in_as(user)
    click_link 'Sign out'
  end

  scenario 'when not signed in' do
    visit root_path
    page.should_not have_xpath('//a', :text => 'Sign out')
  end
     
end
