require 'spec_helper'

describe AccountRequest do
  it { should validate_presence_of(:email) } 
  it { should validate_presence_of(:first_name) } 
  it { should validate_presence_of(:last_name) } 

  it 'requires one associated student'

  it 'validates format of email'
end
