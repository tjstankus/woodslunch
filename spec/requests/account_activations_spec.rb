require 'spec_helper'

describe 'Account activations' do

  describe 'create' do

    before(:each) do
      @account_request = Factory(:account_request)
      @students = [].tap do |a|
        2.times do
          a << Factory(:requested_student,
              :account_request => @account_request)
        end
      end
      @account_request.approve!
    end

    it 'logs user in and redirects to dashboard' do

      # Sanity checks
      @account_request.approved?.should be_true
      @account_request.requested_students.size.should == 2

      # When I visit the new account account request activation page
      visit new_account_request_activation_path(@account_request,
          :token => @account_request.activation_token)

      # Then my email should be displayed as read-only
      page.should have_css('div#email', :text => @account_request.email)

      # And there should be a hidden field containing my email

      # And I fill in the password field

      # And I fill in the password confirmation field

      # And I click Submit

      # Then I should be on my account dashboard page

      # And I should be logged in

      # And I should see link to order for each student
    end
  end

  describe 'new' do
    context 'given an invalid activation token' do
      it 'displays an error message with link to contact email'
    end
  end
end
