require 'spec_helper'

describe 'Accounts search' do
  let!(:user) { Factory(:user, :first_name => 'Marge', :last_name => 'Simpson') }
  let(:account) { user.account }
  let!(:student) { Factory(:student, :first_name => 'Bart', :last_name => 'Simpson', :account => account) }
  let!(:admin) { Factory(:admin) }

  before(:each) do
    sign_in_as(admin)
  end

  it "finds account based on user's first name" do
    visit accounts_path(:q => 'Marge')
    page.should have_css("#account_#{account.id}")
  end
  
  it "finds account based on user's last name"
  it "finds account based on user's email"
  it "finds account based on student's first name"
  it "finds account based on student's last name"

  it "searches case insensitive" do
    visit accounts_path(:q => 'marge')
    page.should have_css("#account_#{account.id}")
  end
end

