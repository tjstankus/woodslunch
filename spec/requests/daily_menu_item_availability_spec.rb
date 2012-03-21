require 'spec_helper'

describe 'Daily menu item availability' do

  context 'given a daily_menu_item' do

    before(:each) do
      # TODO: Refactor this setup code. It's too much, which smells.
      time = Time.now
      @year = time.year
      @month = time.month
      configatron.orders_first_available_on = time.to_date - 1.month
      configatron.orders_last_available_on = time.to_date + 3.months
      @daily_menu_item = Factory(:daily_menu_item)
      @student = create_student
      @user = @student.account.users.first
      sign_in_as @user
    end

    context 'that is not available until next month' do

      before(:each) do
        @availability = Factory(:daily_menu_item_availability)
      end

      it "does not appear on this month's order form" do
        visit student_orders_path(@student, :year => @year, :month => @month)
        page.should_not have_content @daily_menu_item.menu_item.name
      end

      it "appears on next month's order form" do
        visit student_orders_path(@student, :year => @year, :month => @month + 1)
        page.should have_content @daily_menu_item.menu_item.name
      end
    end

    context 'that is available this month' do
      it "appears on this month's order form"
      it "appears on next month's order form"
    end

  end

end