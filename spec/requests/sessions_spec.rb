require 'spec_helper'

describe 'sessions' do

  let(:user) { FactoryGirl.create(:user) }

  
  it 'sign in' do
    sign_in_as(user)
  end

  it 'sign out' do
    sign_in_as(user)
    click_link 'Sign out'
  end
end
