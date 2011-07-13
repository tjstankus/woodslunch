require 'spec_helper'

describe "DaysOff" do

  describe "GET /days_off" do
    it "requires admin" do
      get days_off_path
      response.status.should be(302)
    end
  end

  context 'given I am signed in as an admin' do

    before(:each) do
        sign_in_as(Factory(:admin))
      end

    describe 'create' do
      context 'given valid data' do

        it 'displays the days off on the index listing page' do
          # When I go to the new day off page
          visit new_day_off_path

          # And I fill in the name field
          fill_in 'Name', :with => 'Teacher Workday'

          # And I fill in the starts_on field
          fill_in 'Starts on', :with => '2011-09-09'

          # And I fill in the ends_on field
          fill_in 'Ends on', :with => '2011-09-09'

          # And I submit the form
          click_on 'Submit'

          # Then I should be on the days off index page
          current_path.should == days_off_path

          # And I should see the day off listed
          page.should have_css('span.day_off_name', :text => 'Teacher Workday')
          page.should have_css('span.day_off_date', :text => 'Friday, 09-09-11')
        end
      end
    end

    describe 'delete' do
      context 'given a day off' do

        let!(:day_off) { Factory(:day_off) }

        it 'removes the day off from the index listing' do
          # When I go to the edit day off page
          visit days_off_path
          day_off_div = "div#day_off_#{day_off.id}"
          page.should have_css(day_off_div)
          within day_off_div do
            click_on 'Edit'
          end
          current_path.should == edit_day_off_path(day_off)

          # And I click on Delete
          click_on 'Delete'

          # Then I should be on the days off index page
          current_path.should == days_off_path

          # And I should not see the day off listed
          page.should have_no_css(day_off_div)
        end
      end
    end
  end
end
