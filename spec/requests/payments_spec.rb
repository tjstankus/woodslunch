require 'spec_helper'

describe 'Payments' do

  let!(:admin) { Factory(:admin) }
  let!(:user) { Factory(:user) }
  let(:account) { user.account }

  before(:each) do
    # Background:
    # Given I am signed in as an admin
    sign_in_as(admin)
  end

  describe 'create' do

    it 'displays payment on payments index page' do
      # Given I go to the accounts index
      visit accounts_path

      # TODO: Simplify account partial for listing view, just list users and students,
      #       remove links except for Manage
      # When I click on 'Manage' for the user account
      within("#account_#{account.id}") do
        click_link 'Manage'
      end

      # And I click on 'Payments'
      click_link 'Payments'

      # And I click on 'New payment'
      click_link 'New payment'

      # And I fill in amount with '20.00'
      fill_in 'payment_amount', :with => '20.00'

      # And I fill in notes with 'Check# 1019'
      fill_in 'payment_notes', :with => 'Check# 1019'

      # And I click submit
      click_button 'Submit'

      # Then I should be on the account payments page
      current_path.should == account_payments_path(account)

      # And I should see the payment listed
      page.should have_content('$20.00')
    end
  end

end
