require 'spec_helper'

describe 'Visiting the home page' do

  it 'displays content' do
    visit root_path
    page.should have_xpath('//div[@id="wrapper"]')
  end

end
