require 'spec_helper'

describe 'Visiting the home page' do

  it 'displays content' do
    visit root_path
    page.should have_xpath('//div[@id="wrapper"]')
  end

  # TODO: When this is passing, remove the 'displays content' example
  it 'displays the login form'

  it 'displays a link to the account request page'
end
