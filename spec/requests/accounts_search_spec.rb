require 'spec_helper'

describe 'Accounts search' do
  let!(:user) { Factory(:user, :first_name => 'Marge', :last_name => 'Simpson') }
  let(:account) { user.account }
  let!(:student) { Factory(:student, :first_name => 'Bart', :last_name => 'Simpson', :account => account) }
  let!(:student2) { Factory(:student, :first_name => 'Lisa', :last_name => 'Blacksheep', :account => account) }
  let!(:admin) { Factory(:admin) }

  before(:each) do
    sign_in_as(admin)
  end

  it "finds account based on user's first name" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => 'Marge'
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end
  
  it "finds account based on user's last name" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => 'Simpson'
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end

  it "finds account based on user's email" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => user.email
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end

  it "finds account based on student's first name" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => 'Bart'
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end

  it "finds account based on student's last name" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => 'Blacksheep'
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end

  it "searches case insensitive" do
    visit accounts_path
    within('form#accounts_search') do
      fill_in 'q', :with => 'marge'
    end
    click_button 'Search'
    page.should have_css("#account_#{account.id}")
  end
end

