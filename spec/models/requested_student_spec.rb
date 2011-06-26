require 'spec_helper'

describe RequestedStudent do
  it { should belong_to(:account_request) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:grade) }
end
