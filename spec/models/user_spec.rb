require 'spec_helper'

describe User do
  it { should have_many(:students) }

  describe '#admin?' do
  	context 'given admin role' do
  		it 'returns true' do
        FactoryGirl.build(:admin).has_role?(:admin).should be_true
  		end
  	end

    context 'for non-admin' do
      it 'returns false' do
        FactoryGirl.build(:user).has_role?(:admin).should be_false
      end
    end
  end

end
