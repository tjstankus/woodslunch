require 'spec_helper'

describe Day do

  describe '#wrapped_object' do

    let(:obj) { 'A test string' }
    let(:day) { Day.new(obj) }

    it 'returns the object Day was initialized with' do
      day.wrapped_object.should == obj
    end
  end
end