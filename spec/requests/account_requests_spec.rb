require 'spec_helper'

describe "AccountRequests" do

  # describe "GET /account_requests" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get account_requests_path
  #     response.status.should be(200)
  #   end
  # end

  context 'given I am not logged in' do

    it 'displays new account request link on home page' do
      # Given I am not logged in
      # When I go to the home page
      visit '/'

      # And I follow the account request link
      click_link 'request an account'
    end
  end

  describe 'new account request' do

    before(:each) do
      visit new_account_request_path
    end
    
    it 'displays form' do
      page.should have_xpath("//form[@action='/account_requests']")
    end
    
    it 'requires email'  do
      page.should have_xpath("//input[@id='account_request_email'][@required='required']")
    end

    it 'requires first name' do
      page.should have_xpath("//input[@id='account_request_first_name'][@required='required']")
    end

    it 'requires last name' do
      page.should have_xpath("//input[@id='account_request_last_name'][@required='required']")
    end

    it 'requires at least one student name and grade'

    it 'allows for multiple students'
  end

  describe 'create account request' do

    let(:params) { 
      { 'account_request' => {
          'email'=>'john.doe@example.com', 
          'first_name'=>'John', 
          'last_name'=>'Doe' } }
    }
    
    context 'given no email parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, params['account_request'].except('email')
        assert_select 'div#errorExplanation'
      end
    end
  
    context 'given no first_name parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, params['account_request'].except('first_name')
        assert_select 'div#errorExplanation'
      end
    end

    context 'given no last_name parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, params['account_request'].except('last_name')
        assert_select 'div#errorExplanation'
      end
    end

  end

  describe 'index listing' do
    it 'requires admin permissions'
  end
end
