require 'spec_helper'

describe 'User orders' do

  let!(:account) { Factory(:account) }
  let!(:user) { Factory(:user, :account => account) }
  let(:year) { '2011' }
  let(:month) { '9' }

  before(:each) do
    # Given I am signed in
    sign_in_as(user)
  end

  describe 'when not signed in' do

    before(:each) do
      sign_out
    end

    describe 'GET form' do

      it 'redirects to sign in page' do
        visit user_orders_path(user, :year => year, :month => month)
        current_path.should == new_user_session_path
      end
    end
  end

  describe 'GET form' do

    it 'displays the user name' do
      visit user_orders_path(user, :year => year, :month => month)
      page.should have_content(user.name)
    end

    context 'given a menu item served on Mondays' do

      let!(:daily_menu_item) { create_menu_item_served_on_day('Monday') }
      let!(:menu_item) { daily_menu_item.menu_item }
      let(:ids_for_mondays) { %w(5 12 19 26) }

      before(:each) do
        visit user_orders_path(user, :year => year, :month => month)
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
        user_order = Factory(:user_order, :user => user, :served_on => '2011-09-12')
        ordered_menu_item = Factory(:ordered_menu_item,
                                    :order => user_order,
                                    :menu_item => daily_menu_item.menu_item)
        visit user_orders_path(user, :month => month, :year => year)
        within('#12') do
          within("div#ordered_menu_item_#{ordered_menu_item.id}") do
            page.should have_css('select option[value="1"][selected="selected"]')
          end
        end
      end
    end

    context 'given the user has a preferred_grade' do

      before(:each) do
        user.preferred_grade = '1'
      end

      it 'selects the preferred grade for each orderable date' do
        visit user_orders_path(user, :month => month, :year => year)

      end
    end
  end
end