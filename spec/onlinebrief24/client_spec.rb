require 'spec_helper'

describe Onlinebrief24::Client do
  let(:params) {
    {
      :login    => 'user@example.com',
      :password => 'k1mble',
    }
  }

  describe '#initialize' do
    context 'without parameters' do
      it 'should instantiate' do
        described_class.new.should be_instance_of(Onlinebrief24::Client)
      end
      its(:server) { should eql('api.onlinebrief24.de') }
    end

    context 'with parameters' do
      subject { described_class.new params }

      it { should be_instance_of(Onlinebrief24::Client) }
      its(:login) { should eql(params[:login]) }
      its(:password) { should eql(params[:password]) }
    end
  end

  describe '#upload' do
    subject { described_class.new params }
    let(:letter) { Onlinebrief24::Letter.new letter_filename, letter_options }
    let(:letter_options) { {} }

    describe 'without a letter instance' do
      let(:letter) { nil }

      it { expect{ subject.upload! letter}.to raise_error ArgumentError }
    end

    describe 'with a valid letter' do
      let(:letter_filename) { File.expand_path('../../example_files/example.pdf', __FILE__) }
      let(:letter_options) { { :duplex => true, :color => true, :cost_center => 'eris' } }

      it 'should upload the letter with the correct remote filename' do
        sftp = double('sftp')
        sftp.should_receive(:upload!).with(letter_filename, '/upload/api/' + letter.remote_filename).once

        Net::SFTP.should_receive(:start).with('api.onlinebrief24.de', params[:login], :password => params[:password]) { sftp }

        subject.upload!(letter).should eql('1100000000000_example#eris#.pdf')
      end
    end

    describe 'with an invalid argument' do
      let(:letter) { 'a string which is invalid' }

      it 'should upload the letter with the correct remote filename' do
        expect { subject.upload!(letter) }.to raise_error(ArgumentError)
      end
    end
  end
end

