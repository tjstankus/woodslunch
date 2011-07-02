require 'spec_helper'

describe AccountInvitation do
  it { should belong_to(:account_request) }
  it { should validate_presence_of(:account_request_id) }

  it 'creates token before create'

  it 'sends email after create'

  it 'approves account request after create'
end