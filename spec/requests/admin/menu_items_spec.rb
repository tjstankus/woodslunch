require 'spec_helper'

describe 'Managing menu items' do

  context 'when logged in as an admin' do

    let(:admin) { FactoryGirl.create(:admin) }

    before(:each) do
      sign_in_as(admin)   
    end


  end
end
