require 'spec_helper'

describe 'Students' do

  let!(:user) { Factory(:user) }
  let!(:account) { user.account }

  before(:each) do
    sign_in_as(user)
  end

  describe 'GET new' do
    it 'displays new student form' do
      # Given I go to my account management page
      visit account_path(account)

      # And I click on 'Add a student'
      click_link 'Add a student'

      # When I fill in first name with 'Bart'
      fill_in 'First name', :with => 'Bart'

      # And I fill in last name with 'Simpson'
      fill_in 'Last name', :with => 'Simpson'

      # And I select '3' from 'Grade'
      select '3', :from => 'Grade'

      # And I click on 'Submit'
      click_button 'Create Student'

      # Then I should be back on my account management page
      current_path.should == account_path(account)

      # And I should see 'Bart Simpson, grade: 3' listed under Students
      page.should have_css("div.student span.student_info", :text => "Bart Simpson, grade 3")
    end
  end

  describe 'POST create' do
    it 'creates a student'
  end

  describe 'GET edit' do
    it 'displays edit student form'
  end

  describe 'PUT update' do
    it 'updates student information'
  end
end