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
  end
end