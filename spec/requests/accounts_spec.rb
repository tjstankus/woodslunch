require 'spec_helper'

describe 'Accounts' do

  it 'displays balance on home page' do
    pending
    
    # Given I am signed in
    user = FactoryGirl.create(:user)
    sign_in_as(user)

    # When I visit the home page
    current_path.should == root_path

    # TODO: Then I should see my account balance
  end

  describe 'balance' do
    
    it 'updates with lunch order' do
      # Given I am a signed in user with a student
      student = FactoryGirl.create(:student)
      user = student.user
      sign_in_as(user)

      # And I have an account
      account = FactoryGirl.create(:account)
      account.users << user
      account.save!

      # When I go to the lunch order form
      # visit edit_student_order_path

      # And I place a lunch order for one item
      # Then my account balance should increment the cost of the item
    end
  end

end
