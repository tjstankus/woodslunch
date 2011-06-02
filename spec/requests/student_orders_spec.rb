require 'spec_helper'

describe 'Student orders' do
  
  context 'a signed in user with associated student' do

    let!(:student) { FactoryGirl.create(:student) }
    let!(:user) { student.user }

    before(:each) do
      # Given I am signed in
      sign_in_as(user)
    end

    it 'views order form for that student' do
      # When I go to the home page
      visit root_path

      # And I click on the student order link
      click_on "Lunch order for #{student.name}"

      # Then I should see the order form for that student
      page.should have_content(student.name)
    end
    
    it 'cannot view student order form for unassociated student'
  end
end
