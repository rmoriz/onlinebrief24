require 'spec_helper'

describe Onlinebrief24::Client do
  let(:params) {
    {
      :login    => 'user@example.com',
      :password => 'k1mble'
    }
  }

  describe '#initialize' do
    context 'without parameters' do
      it 'should instantiate' do
        described_class.new.should be_instance_of(Onlinebrief24::Client)
      end
    end

    context 'with parameters' do
      subject { described_class.new params }

      it { should be_instance_of(Onlinebrief24::Client) }
      its(:login) { should eql(params[:login]) }
      its(:password) { should eql(params[:password]) }
    end
  end
end
