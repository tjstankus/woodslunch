require 'spec_helper'

describe User do

  it 'should be an admin' do
    FactoryGirl.build(:admin).admin?.should be_true
  end

end
