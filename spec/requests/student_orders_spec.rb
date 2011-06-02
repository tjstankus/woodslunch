require 'spec_helper'

describe 'Student orders' do

  let(:student) { FactoryGirl.create(:student) }
  let(:user) { student.user }

  context 'a signed in user with associated student' do

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

  describe 'GET /students/:student_id/:year/:month' do

    let(:month) { '5' }
    let(:year) { '2011' }

    before(:each) do
      visit student_order_path(student, :year => year, :month => month)
    end
    
    it 'displays month' do
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'May')]]")
    end

    it 'displays year' do
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'#{year}')]]")
    end

    it 'displays student name' do
      page.should have_xpath("//h2[@id='student_name']" + 
        "[text()[contains(.,'#{student.name}')]]")
    end

    it 'displays weekdays' do
      DayOfWeek.weekdays.collect(&:name).each do |day|
        page.should have_content(day)
      end
    end
  end
end
