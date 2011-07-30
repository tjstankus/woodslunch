require 'spec_helper'

describe 'Student orders' do

  let!(:account) { Factory(:account) }
  let!(:student) { Factory(:student, :account => account) }
  let!(:user) { Factory(:user, :account => account) }

  before(:each) do
    # Given I am signed in
    sign_in_as(user)
  end

  context 'a signed in user with associated student' do

    it 'views order form for that student' do
      # When I go to the home page
      visit root_path

      # And I click on the student order link
      click_on "Lunch order for #{student.name}"

      # Then I should see the order form for that student
      page.should have_content(student.name)
    end

    context 'that attempts to edit an order for an unassociated student' do

      let(:account2) { Factory(:account) }
      let(:unassociated_student) { Factory(:student, :account => account2) }

      it 'gets redirected to the root path' do
        visit edit_student_order_path(unassociated_student, :year => '2011', :month => '4')
        current_path.should == root_path
      end

      it 'sees a flash alert message' do
        visit edit_student_order_path(unassociated_student, :year => '2011', :month => '4')
        alert = 'Cannot place orders for students not associated with your account.'
        page.should have_css('.flash#alert', :text => alert)
      end
    end
  end

  describe 'when not signed in' do

    before(:each) do
      sign_out
    end

    describe 'GET /students/:student_id/:year/:month' do

      it 'redirects to sign in page' do
        visit edit_student_order_path(student, :year => '2011', :month => '4')
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET /students/:student_id/orders/:year/:month' do

    let(:month) { '5' }
    let(:year) { '2011' }

    it 'displays month' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'May')]]")
    end

    it 'displays year' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'#{year}')]]")
    end

    it 'displays student name' do
      visit edit_student_order_path(student, :year => year, :month => month)
      page.should have_xpath("//*[@id='student_name']" +
        "[text()[contains(.,'#{student.name}')]]")
    end

    it 'displays weekdays' do
      visit edit_student_order_path(student, :year => year, :month => month)
      DayOfWeek.weekdays.collect(&:name).each do |day|
        page.should have_content(day)
      end
    end

    context 'given a menu item served on Mondays' do

      before(:each) do
        @daily_menu_item = create_menu_item_served_on_day('Monday')
        @menu_item = @daily_menu_item.menu_item
      end

      it 'displays the menu item on each Monday' do
        visit edit_student_order_path(student, :year => year, :month => month)

        ids_for_mondays = %w(2 9 16 23 30)
        ids_for_mondays.each do |id|
          within("td##{id}") do
            page.should have_content(@menu_item.name)
          end
        end
      end
    end

    context 'given an ordered menu item' do
      it 'should be have a quantity selected'
    end

    context 'given a range of days off within the month' do

      let!(:days_off) do
        Factory(:day_off, :name => 'Memorial Day Break', :starts_on => "#{year}-#{month}-26",
            :ends_on => "#{year}-#{month}-31")
      end
      let(:affected_days) { %w(26 27 30 31) }

      it 'displays the name of the day off for each affected day' do
        visit edit_student_order_path(student, :year => year, :month => month)
        affected_days.each do |day|
          within "td##{day}" do
            page.should have_css('div.day_off', :text => days_off.name)
          end
        end
      end

      it 'does not display menu items on days off' do
        visit edit_student_order_path(student, :year => year, :month => month)
        affected_days.each do |day|
          within "td##{day}" do
            page.should_not have_css('input')
          end
        end
      end
    end
  end

  describe 'POST /students/:student_id/orders' do

    let(:month) { '6' }
    let(:year) { '2011' }

    it 'creates an order' do
      # Given a menu item Hamburger served on Mondays
      menu_item = Factory(:menu_item, :name => 'Hamburger')
      Factory(:daily_menu_item,
        :menu_item => menu_item,
        :day_of_week => DayOfWeek.find_by_name('Monday'))

      # When I go to the student order form
      visit edit_student_order_path(student, :year => year, :month => month)

      # And I check Hamburger for the first Monday
      within('td#6') do
        check 'Hamburger'
      end

      # And I click Place Order
      click_button 'Place Order'

      # Then I should see a successful order flash message displayed
      page.should have_xpath("//div[@id='notice']",
                             :text => "Successfully placed order for #{student.name}")

    end
  end
end
