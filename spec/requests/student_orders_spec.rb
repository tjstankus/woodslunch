require 'spec_helper'

describe 'Student orders' do

  # Setup an account with a user and associated student
  let!(:account) { Factory(:account) }
  let!(:user) { Factory(:user, :account => account) }
  let!(:student) { Factory(:student, :account => account) }

  let(:year) { '2011' }
  let(:month) { '9' }

  before(:each) do
    # Given I am signed in
    sign_in_as(user)
  end

  describe 'when not signed in' do

    before(:each) do
      # Given I am not signed in
      sign_out
    end

    describe 'GET new student order' do

      it 'redirects to sign in page' do
        # When I visit the new student order page
        visit new_student_order_path(student, :year => year, :month => month)

        # Then I should be redirected to the login page
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET new student order' do

    it 'displays the student name' do
      # When I visit the new student order page
      visit new_student_order_path(student, :year => year, :month => month)

      # Then I should see the student name
      page.should have_content(student.name)
    end

    context 'given a menu item served on Mondays' do

      let!(:daily_menu_item) { create_menu_item_served_on_day('Monday') }
      let!(:menu_item) { daily_menu_item.menu_item }
      let(:ids_for_mondays) { %w(5 12 19 26) }

      before(:each) do
        visit new_student_order_path(student, :year => year, :month => month)
      end

      it 'displays the menu item on each Monday' do
        ids_for_mondays.each do |id|
          within("td##{id}") do
            page.should have_content(menu_item.name)
          end
        end
      end

      it 'displays a quantity select for the menu item' do
        ids_for_mondays.each do |id|
          within("td##{id}") do
            page.should have_css('select')
          end
        end
      end
    end
  end

  describe 'POST create student order' do

    before(:each) do
      # Given a menu item for each day of the week
      DayOfWeek.all.each do |day_of_week|
        Factory(:daily_menu_item, :day_of_week => day_of_week)
      end
      # And a second menu item for one of the days of the week
      Factory(:daily_menu_item, :day_of_week => DayOfWeek.first)
    end

    context 'for a single menu item' do

      before(:each) do
        # When I visit the new student order page
        visit new_student_order_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for a single menu item
        within('td#9') do
          select '1', :from => 'student_order_orders_attributes_9_ordered_menu_items_attributes_0_quantity'
        end
      end

      it 'creates one StudentOrder' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(1)
      end

      it 'creates one Order' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one Order gets created
        }.to change { Order.count }.from(0).to(1)
      end

      it 'creates one OrderedMenuItem' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one OrderedMenuItem gets created
        }.to change { OrderedMenuItem.count }.from(0).to(1)
      end

      it 'updates account balance by the price of the ordered menu item'
    end

    context 'for multiple menu items on one day' do

      before(:each) do
        # When I visit the new student order page
        visit new_student_order_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for two menu items
        within('td#12') do
          select '1', :from => 'student_order_orders_attributes_12_ordered_menu_items_attributes_0_quantity'
          select '1', :from => 'student_order_orders_attributes_12_ordered_menu_items_attributes_1_quantity'
        end
      end

      it 'creates one StudentOrder' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(1)
      end

      it 'creates one Order'do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one Order gets created
        }.to change { Order.count }.from(0).to(1)
      end

      it 'creates multiple OrderedMenuItems' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then two OrderedMenuItems get created
        }.to change { OrderedMenuItem.count }.from(0).to(2)
      end
    end

    context 'for menu items on multiple days' do
      before(:each) do
        # When I visit the new student order page
        visit new_student_order_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for a single menu item on two different days
        within('td#9') do
          select '1', :from => 'student_order_orders_attributes_9_ordered_menu_items_attributes_0_quantity'
        end

        within('td#16') do
          select '1', :from => 'student_order_orders_attributes_16_ordered_menu_items_attributes_0_quantity'
        end
      end

      it 'creates one StudentOrder' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(1)
      end

      it 'creates multipls Orders'do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one Order gets created
        }.to change { Order.count }.from(0).to(2)
      end

      it 'creates multiple OrderedMenuItems' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then two OrderedMenuItems get created
        }.to change { OrderedMenuItem.count }.from(0).to(2)
      end
    end
  end

  describe 'GET edit student order' do

    it 'displays quantity for ordered menu item' do
      pending 'Edit form revamp.'

      daily_menu_item = Factory(:daily_menu_item, :day_of_week => DayOfWeek.first)
      student_order = Factory(:student_order,
                              :student => student,
                              :starts_on => '2011-09-01',
                              :ends_on => '2011-09-30')
      order = Factory(:order, :student_order => student_order, :served_on => '2011-09-12')
      ordered_menu_item = Factory(:ordered_menu_item,
                                  :order => order,
                                  :menu_item => daily_menu_item.menu_item)
      visit edit_student_order_path(student, student_order, :month => month, :year => year)
      puts page.body
      # within('#12') do
      #   :from => 'student_order_orders_attributes_9_ordered_menu_items_attributes_0_quantity'
      # end
    end
  end

end

# For number_to_currency
# include ActionView::Helpers::NumberHelper


# let!(:user) { Factory(:user, :account => account) }

# before(:each) do
#   # Given I am signed in
#   sign_in_as(user)
# end

# context 'a signed in user with associated student' do

#   it 'views order form for that student' do
#     # When I go to the home page
#     visit root_path

#     # And I click on the student order link
#     click_on "Lunch order for #{student.name}"

#     # Then I should see the order form for that student
#     page.should have_content(student.name)
#   end

#   context 'that attempts to edit an order for an unassociated student' do

#     let(:account2) { Factory(:account) }
#     let(:unassociated_student) { Factory(:student, :account => account2) }

#     it 'gets redirected to the root path' do
#       visit edit_student_order_path(unassociated_student, :year => '2011', :month => '4')
#       current_path.should == root_path
#     end

#     it 'sees a flash alert message' do
#       visit edit_student_order_path(unassociated_student, :year => '2011', :month => '4')
#       alert = 'Cannot place orders for students not associated with your account.'
#       page.should have_css('.flash#alert', :text => alert)
#     end
#   end
# end



# describe 'GET /students/:student_id/orders/:year/:month' do

#   let(:month) { '5' }
#   let(:year) { '2011' }

#   it 'displays month' do
#     visit edit_student_order_path(student, :year => year, :month => month)
#     page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'May')]]")
#   end

#   it 'displays year' do
#     visit edit_student_order_path(student, :year => year, :month => month)
#     page.should have_xpath("//h3[@id='month_year'][text()[contains(.,'#{year}')]]")
#   end

#   it 'displays student name' do
#     visit edit_student_order_path(student, :year => year, :month => month)
#     page.should have_xpath("//*[@id='student_name']" +
#       "[text()[contains(.,'#{student.name}')]]")
#   end

#   it 'displays weekdays' do
#     visit edit_student_order_path(student, :year => year, :month => month)
#     DayOfWeek.weekdays.collect(&:name).each do |day|
#       page.should have_content(day)
#     end
#   end

#   context 'given a menu item served on Mondays' do

#     before(:each) do
#       @daily_menu_item = create_menu_item_served_on_day('Monday')
#       @menu_item = @daily_menu_item.menu_item
#     end

#     let(:ids_for_mondays) { %w(2 9 16 23 30) }

#     it 'displays the menu item on each Monday' do
#       visit edit_student_order_path(student, :year => year, :month => month)
#       ids_for_mondays.each do |id|
#         within("td##{id}") do
#           page.should have_content(@menu_item.name)
#         end
#       end
#     end

#     it 'displays a quantity select for the menu item' do
#       pending
#       visit edit_student_order_path(student, :year => year, :month => month)
#       ids_for_mondays.each do |id|
#         within("td##{id}") do
#           page.should have_css('select')
#         end
#       end
#     end
#   end

#   context 'given an ordered menu item' do
#     it 'should be have a quantity selected'
#   end

#   context 'given a range of days off within the month' do

#     let!(:days_off) do
#       Factory(:day_off, :name => 'Memorial Day Break', :starts_on => "#{year}-#{month}-26",
#           :ends_on => "#{year}-#{month}-31")
#     end
#     let(:affected_days) { %w(26 27 30 31) }

#     it 'displays the name of the day off for each affected day' do
#       visit edit_student_order_path(student, :year => year, :month => month)
#       affected_days.each do |day|
#         within "td##{day}" do
#           page.should have_css('div.day_off', :text => days_off.name)
#         end
#       end
#     end

#     it 'does not display menu items on days off' do
#       visit edit_student_order_path(student, :year => year, :month => month)
#       affected_days.each do |day|
#         within "td##{day}" do
#           page.should_not have_css('input')
#         end
#       end
#     end
#   end
# end

# describe 'POST /students/:student_id/orders' do

#   let(:month) { '6' }
#   let(:year) { '2011' }

#   # Given a menu item Hamburger served on Mondays
#   let!(:menu_item) { Factory(:menu_item, :name => 'Hamburger') }
#   let!(:daily_menu_item) {
#     Factory(:daily_menu_item,
#             :menu_item => menu_item,
#             :day_of_week => DayOfWeek.find_by_name('Monday'))
#   }

#   it 'creates an order' do
#     # When I go to the student order form
#     visit edit_student_order_path(student, :year => year, :month => month)

#     # And select a quantity of 1 Hamburger for the first Monday
#     within('td#6') do
#       within('div.menu_item') do
#         select '1'
#       end
#     end

#     # And I click Place Order
#     click_button 'Place Order'

#     # Then I should see a successful order flash message displayed
#     page.should have_xpath("//div[@id='notice']",
#                            :text => "Successfully placed order for #{student.name}")
#   end

#   it 'changes the account balance' do
#     # And given a 0 account balance
#     account.balance.should == 0

#     # When I go to the student order form
#     visit edit_student_order_path(student, :year => year, :month => month)

#     # And select a quantity of 1 Hamburger for the first Monday
#     within('td#6') do
#       within('div.menu_item') do
#         select '1'
#       end
#     end

#     # And I click Place Order
#     click_button 'Place Order'

#     # Then I should be back on my dashboard page
#     current_path.should == root_path

#     # And I should see my updated account balance
#     page.should have_css('#balance', :text => number_to_currency(menu_item.price))
#   end
# end