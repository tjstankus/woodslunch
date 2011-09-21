require 'spec_helper'

describe 'Students' do

  let!(:user) { Factory(:user) }
  let!(:account) { user.account }

  before(:each) do
    sign_in_as(user)
  end

  it 'creates a new student' do
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
    page.should have_css("div.student span.student_info a", :text => "Bart Simpson")
  end

  it 'updates student information' do
    student = Factory(:student, :grade => '1', :account => account)
    visit account_path(account)
    within("div#student_#{student.id}") do
      click_link 'Edit'
    end
    select '2', :from => 'Grade'
    click_button 'Update Student'
    current_path.should == account_path(account)
    page.should have_css("div.student span.student_info a", :text => "#{student.name}")
  end

  it 'destroys a student' do
    pending 'Will need to destroy any student orders and update balance properly.'
  end

end
