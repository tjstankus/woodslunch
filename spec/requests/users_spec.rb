require 'spec_helper'

describe 'Users' do

  let!(:user) { Factory(:user) }

  before(:each) do
    sign_in_as(user)
  end

  describe 'GET edit' do
    it 'displays form' do
      visit edit_user_path(user)
      page.should have_css('form')
    end
  end

  describe 'PUT update' do
    it 'redirects to root (dashboard) path' do
      visit edit_user_path(user)
      select '2', :from => 'user_preferred_grade'
      click_button 'Submit'
      page.current_path.should == dashboard_path
    end

    it 'displays flash notice' do

    end
    it 'sets preferred_grade' do
      visit edit_user_path(user)
      select '2', :from => 'user_preferred_grade'
      expect {
        click_button 'Submit'
      }.to change { user.reload.preferred_grade }.from(nil).to('2')
    end
  end

  describe 'GET edit security' do
    it 'disallows viewing of other user edit pages'

    it 'allows viewing of other user edit pages by admins'
  end
end