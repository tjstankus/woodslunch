require 'spec_helper'

describe 'Reports' do

  let!(:admin) { Factory(:admin) }

  before(:each) do
    sign_in_as(admin)
  end

  context 'GET index' do
    context 'without date parameter' do

      before(:each) do
        visit reports_path
      end

      it 'displays date selector' do
        page.should have_css('#date_selector')
      end

      it 'does not display orders'
    end

    context 'with date parameter' do

      let!(:ordered_menu_item) { Factory(:ordered_menu_item) }
      let!(:order) { ordered_menu_item.order }

      before(:each) do
        visit reports_path(:date => order.served_on)
      end

      it 'displays student order for date' do
        page.should have_css("#student_order_#{order.id}")
      end

      it 'displays name associated with student order' do
        within("#student_order_#{order.id}") do
          page.should have_css('td.first_name', :text => order.student.first_name)
          page.should have_css('td.last_name', :text => order.student.last_name)
        end
      end

      it 'displays ordered menu items'
    end
  end
end