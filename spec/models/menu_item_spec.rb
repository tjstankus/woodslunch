require 'spec_helper'

describe MenuItem do
  it { should validate_presence_of(:name) }

  context 'given a saved menu item' do
    let!(:menu_item) { FactoryGirl.create(:menu_item) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end