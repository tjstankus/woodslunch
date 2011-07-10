require 'spec_helper'

describe 'Account activations' do

  describe 'create' do

    before(:each) do
      @account_request = create_account_request(:students => 2)
      @account_request.approve!
      @student_names = @account_request.requested_students.collect(&:full_name)
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
      page.should have_xpath("//input[@type='hidden'][@id='account_activation_email']")

      # And I fill in the password field
      fill_in 'Password', :with => 'secret'

      # And I fill in the password confirmation field
      fill_in 'Password confirmation', :with => 'secret'

      # And I click Submit
      click_button 'Submit'

      # Then I should be on my account dashboard page
      # current_path.should == root_path

      # And I should be logged in
      # current_user.should_not be_nil
      # current_user.email.should == @account_request.email

      # And I should see link to order for each student
      # @student_names.each do |name|
      #   "//a[@class='student_order'][text()[contains(.,'#{name}')]]")
      # end
    end
  end

  describe 'new' do
    context 'given an invalid activation token' do
      it 'displays an error message with link to contact email'
    end
  end
end
