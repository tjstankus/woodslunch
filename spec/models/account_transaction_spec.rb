require 'spec_helper'

describe AccountTransaction do
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount) }
end
