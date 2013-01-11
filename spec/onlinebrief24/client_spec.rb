require 'spec_helper'

describe Onlinebrief24::Client do
  describe '#initialize' do
    it 'should instantiate' do
      described_class.new.should_not be_nil
    end
  end
end
