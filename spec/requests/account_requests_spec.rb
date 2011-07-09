require 'spec_helper'

describe "AccountRequests" do

  describe 'home page' do

    context 'given I am not logged in' do

      it 'displays new account request link' do
        # When I go to the home page
        visit '/'

        # And I follow the account request link
        click_link 'request an account'
      end
    end
  end

  describe 'new' do

    before(:each) do
      visit new_account_request_path
    end

    it 'displays form' do
      page.should have_xpath("//form[@action='/account_requests']")
    end

    it 'displayes required email'  do
      page.should have_xpath("//input[@id='account_request_email'][@required='required']")
    end

    it 'displays required first name' do
      page.should have_xpath("//input[@id='account_request_first_name'][@required='required']")
    end

    it 'displays required last name' do
      page.should have_xpath("//input[@id='account_request_last_name'][@required='required']")
    end

    it 'displays required student first name' do
      id = 'account_request_requested_students_attributes_0_first_name'
      page.should have_xpath("//input[@id='#{id}'][@required='required']")
    end

    it 'displays required student last name' do
      id = 'account_request_requested_students_attributes_0_last_name'
      page.should have_xpath("//input[@id='#{id}'][@required='required']")
    end

    it 'displays required student grade' do
      id = 'account_request_requested_students_attributes_0_grade'
      page.should have_xpath("//select[@id='#{id}'][contains(@class, 'required')]")
    end

    it 'allows for multiple students'
  end

  describe 'create' do

    let(:valid_params) {
      { 'account_request' => {
          'email'=>'john.doe@example.com',
          'first_name'=>'John',
          'last_name'=>'Doe',
          'requested_students_attributes' => {
            '0' => { 'first_name' => 'Bart',
                     'last_name' => 'Simpson',
                     'grade' => '4' } } } }
    }

    context 'given valid params' do
      it 'redirects to home page with flash message' do
        # post_via_redirect account_requests_path, valid_params

        # Given I go to the new account request page
        visit new_account_request_path

        # And I fill in 'Email' with 'marge.simpson@example.com'
        fill_in 'Email', :with => 'marge.simpson@example.com'

        # And I fill in 'First name' with 'Marge'
        fill_in 'First name', :with => 'Marge'

        # And I fill in 'Last name' with 'Simpson'
        fill_in 'Last name', :with => 'Simpson'

        # And I fill in 'Student first name' with 'Bart'
        fill_in 'account_request_requested_students_attributes_0_first_name',
            :with => 'Bart'

        # And I fill in 'Student last name' with 'Simpson'
        fill_in 'account_request_requested_students_attributes_0_last_name',
            :with => 'Simpson'

        # And I select '4' from 'Student grade'
        select '4',
            :from => 'account_request_requested_students_attributes_0_grade'

        # And I click 'Submit Request'
        click_button 'Submit Request'

        # Then I should be redirected to the home page
        current_path.should == root_path

        # And I should see a flash message stating
        #     'Account request successfully submitted'
        partial_flash = 'Account request successfully submitted'
        page.should have_xpath(
            "//div[@class='flash'][@id='notice'][text()[contains(.,'#{partial_flash}')]]")
      end
    end

    context 'given no email parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, valid_params['account_request'].except('email')
        assert_select 'div#error_explanation'
      end
    end

    context 'given no first_name parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, valid_params['account_request'].except('first_name')
        assert_select 'div#error_explanation'
      end
    end

    context 'given no last_name parameter' do
      it 'displays error message' do
        post_via_redirect account_requests_path, valid_params['account_request'].except('last_name')
        assert_select 'div#error_explanation'
      end
    end

    context 'given an email for an existing account' do
      it 'redirects to sign in page with flash message'
    end

  end

  describe 'index listing' do

    context 'given I am not logged in' do

      it 'redirects to the home page' do
        # When I go to the account requests index page
        visit account_requests_path

        # Then I should be redirected to the home page
        current_path.should == root_path
      end
    end

    context 'given I am logged in as a user' do

      before(:each) do
        user = Factory(:user)
        sign_in_as(user)
      end

      it 'redirects to the home page' do
        # When I go to the account requests index page
        visit account_requests_path

        # Then I should be redirected to the home page
        current_path.should == root_path
      end
    end

    context 'given I am logged in as an admin' do

      before(:each) do
        admin = Factory(:admin)
        sign_in_as(admin)
      end

      it 'permits access' do
        # When I go to the account requests index page
        visit account_requests_path

        # Then I should be redirected to the home page
        current_path.should == account_requests_path
      end

      context 'given an account request with two associated students' do

        let(:account_request) { Factory(:account_request) }
        let(:students) {
          [].tap do |a|
            a << Factory(:requested_student,
                :account_request => account_request)
          end
        }

        it 'displays user and student info' do
          # When I go to the account requests index page
          visit account_requests_path

          # Then I should see user info
          # And I should see students info
        end
      end
    end
  end

  describe 'approve' do

    before(:each) do
      # Given an account request
      @account_request = Factory(:account_request)
      # And I am logged in as an admin
      @admin = Factory(:admin)
      sign_in_as(@admin)
    end

    it 'sends email with activation token' do
      # When I go to the account requests listing
      visit account_requests_path

      # And I clock on the "Approve" button
      within("div#pending div#account_request_#{@account_request.id}") do
        click_button 'Approve'
      end

      # Then I should be back on the account requests listing page
      current_path.should == account_requests_path

      # And I should see a flash notice 'Account invitation has been sent'
      flash_notice = "An account invitation has been sent to " +
          "#{@account_request.email}"
      page.should have_css('div#notice', :text => flash_notice)

      # And I should see the account request listed under 'Approved'
      page.should have_css('div#approved span.user_info',
          :text => "#{@account_request.full_name}")
    end
  end

  describe 'activate' do
    context 'given an approved request' do

      context 'and valid data' do
        before(:each) do
          @account_request = Factory(:account_request)
          @students = 2.times do
            [].tap do |a|
              a << Factory(:requested_student,
                  :account_request => @account_request)
            end
          end
          @account_request.approve!
        end

        it 'redirects to new account page' do

          # Sanity checks
          @account_request.approved?.should be_true
          @account_request.requested_students.size.should == 2

          # When I visit the account activation path
          visit account_activation_path(@account_request,
              :token => @account_request.activation_token)

          # Then I should be redirected to the new account page
          current_path.should == new_account_path

          # And my email should be displayed as read-only

          # And there should be a hidden field containing my email

          # And I fill in the password field

          # And I fill in the password confirmation field

          # And I click Submit

          # Then I should be on my account dashboard page

          # And I should be logged in

          # And I should see link to order for each student
        end
      end

      context 'and an invalid activation token' do
        it 'displays an error message'
        it 'displays a link to contact email'
      end
    end
  end
end
