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

    describe 'GET form' do

      it 'redirects to sign in page' do
        # When I visit the new student order page
        visit student_orders_path(student, :year => year, :month => month)

        # Then I should be redirected to the login page
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET form' do

    it 'displays the student name' do
      # When I visit the new student order page
      visit student_orders_path(student, :year => year, :month => month)

      # Then I should see the student name
      page.should have_content(student.name)
    end

    context 'given a menu item served on Mondays' do

      let!(:daily_menu_item) { create_menu_item_served_on_day('Monday') }
      let!(:menu_item) { daily_menu_item.menu_item }
      let(:ids_for_mondays) { %w(5 12 19 26) }

      before(:each) do
        visit student_orders_path(student, :year => year, :month => month)
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

    context 'given an existing order' do

      it 'displays quantity for ordered menu item' do
        daily_menu_item = Factory(:daily_menu_item, :day_of_week => DayOfWeek.first)
        student_order = Factory(:student_order, :student => student, :served_on => '2011-09-12')
        ordered_menu_item = Factory(:ordered_menu_item,
                                    :order => student_order,
                                    :menu_item => daily_menu_item.menu_item)
        visit student_orders_path(student, :month => month, :year => year)
        within('#12') do
          within("div#ordered_menu_item_#{ordered_menu_item.id}") do
            page.should have_css('select option[value="1"][selected="selected"]')
          end
        end
      end

    end
  end

  describe 'creating' do

    before(:each) do
      # Given a menu item for each day of the week
      DayOfWeek.all.each do |day_of_week|
        Factory(:daily_menu_item, :day_of_week => day_of_week)
      end
      # And a second menu item for one of the days of the week
      Factory(:daily_menu_item, :day_of_week => DayOfWeek.first)
    end

    context 'a single menu item' do

      before(:each) do
        # When I visit the new student order page
        visit student_orders_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for a single menu item
        within('td#9') do
          select '1', :from => 'student_orders_9_ordered_menu_items_attributes_0_quantity'
        end
      end

      it 'creates one StudentOrder' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(1)
      end

      it 'creates one OrderedMenuItem' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one OrderedMenuItem gets created
        }.to change { OrderedMenuItem.count }.from(0).to(1)
      end

      it 'sets order_id for OrderedMenuItem'

      it 'updates account balance by the price of the ordered menu item'
    end

    context 'multiple menu items for one day' do

      before(:each) do
        # When I visit the new student order page
        visit student_orders_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for two menu items
        within('td#12') do
          select '1', :from => 'student_orders_12_ordered_menu_items_attributes_0_quantity'
          select '1', :from => 'student_orders_12_ordered_menu_items_attributes_1_quantity'
        end
      end

      it 'creates one StudentOrder' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(1)
      end

      it 'creates multiple OrderedMenuItems' do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then two OrderedMenuItems get created
        }.to change { OrderedMenuItem.count }.from(0).to(2)
      end
    end

    context 'menu items on multiple days' do
      before(:each) do
        # When I visit the new student order page
        visit student_orders_path(student, :year => year, :month => month)

        # And I select a quantity of 1 for a single menu item on two different days
        within('td#9') do
          select '1', :from => 'student_orders_9_ordered_menu_items_attributes_0_quantity'
        end

        within('td#16') do
          select '1', :from => 'student_orders_16_ordered_menu_items_attributes_0_quantity'
        end
      end

      it 'creates multiple StudentOrders'do
        expect {
          # And I click 'Place Order'
          click_button 'Place Order'
          # Then one StudentOrder gets created
        }.to change { StudentOrder.count }.from(0).to(2)
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

  describe 'updating' do

    before(:each) do
      # Given a menu item for each day of the week
      DayOfWeek.all.each do |day_of_week|
        Factory(:daily_menu_item, :day_of_week => day_of_week)
      end
      # And a second menu item for one of the days of the week
      Factory(:daily_menu_item, :day_of_week => DayOfWeek.first)
    end

    context 'an ordered menu item' do

      let!(:daily_menu_item) { Factory(:daily_menu_item, :day_of_week => DayOfWeek.first) }
      let!(:student_order) do
        Factory(:student_order, :student => student, :served_on => '2011-09-12')
      end
      let!(:ordered_menu_item) do
        Factory(:ordered_menu_item,
                :order => student_order,
                :menu_item => daily_menu_item.menu_item)
      end

      context 'changing quantity from 1 to 2' do

        it 'updates the quantity' do
          visit student_orders_path(student, :month => month, :year => year)
          within('#12') do
            within("div#ordered_menu_item_#{ordered_menu_item.id}") do
              select '2'
            end
          end
          expect {
            click_button 'Place Order'
          }.to change { ordered_menu_item.reload.quantity }.from(1).to(2)
        end
      end

      context 'changing quantity to blank' do

        it 'destroys the ordered menu item' do
          pending 'JavaScript driver'

          visit student_orders_path(student, :month => month, :year => year)
          within('#12') do
            within("div#ordered_menu_item_#{ordered_menu_item.id}") do
              select ''
            end
          end
          expect {
            click_button 'Place Order'
          }.to change { OrderedMenuItem.count }.by(-1)
        end

        it 'destroys the order, since it has no ordered menu items' do
          pending 'JavaScript driver'
        end

        it 'destroys the student order, since it has no orders' do
          pending 'JavaScript driver'
        end
      end
    end
  end
end
