require 'spec_helper'

describe StudentOrder do
  
  context 'a signed in user with associated student' do

    let!(:student) { FactoryGirl.create(:student) }
    let!(:user) { student.user }

    before(:each) do
      # Given I am signed in
      sign_in_as(user)
    end

    it 'should be able to view order form for that student' do
      # When I go to the home page
      visit root_path

      # And I click on the student order link
      click_on "Lunch order for #{student.name}"
    end
    
    it 'should not be able to view student order form for unassociated student'
  end
end
