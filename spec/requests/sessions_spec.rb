require 'spec_helper'

describe 'sessions' do

  let(:user) { FactoryGirl.create(:user) }

  it 'sign in' do
    visit new_user_session_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Sign in'
    page.should have_xpath('//div[@id="notice"]', :text => 'Signed in successfully.')
  end

  it 'sign out'
end
