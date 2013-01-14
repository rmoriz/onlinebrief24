require 'spec_helper'

describe Onlinebrief24::Client do
  let(:params) {
    {
      :login    => 'user@example.com',
      :password => 'fefe_isst_gerne_schweinshaxn',
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
    let(:local_path) { File.expand_path('../../example_files/example.pdf', __FILE__) }
    let(:letter) { Onlinebrief24::Letter.new(local_path, letter_options) }
    let(:letter_options) { {} }

    describe 'without a letter instance' do
      let(:letter) { nil }

      it { expect{ subject.upload! letter}.to raise_error ArgumentError }
    end

    describe 'with a valid letter instance' do
      let(:letter_options) { { :duplex => true, :color => true, :cost_center => 'eris' } }

      it 'should upload the letter with the correct remote filename' do
        sftp = double('sftp')
        sftp.should_receive(:upload!).with(local_path, '/upload/api/' + letter.remote_filename).once

        Net::SFTP.should_receive(:start).with('api.onlinebrief24.de', params[:login], :password => params[:password]) { sftp }

        subject.upload!(letter).should eql('1100000000000_example#eris#.pdf')
      end
    end

    describe 'with a file handle' do
      let(:filehandle) { File.open(local_path) }

      it 'should upload the letter with the correct remote filename' do
        sftp = double('sftp')
        sftp.should_receive(:upload!).with(local_path, '/upload/api/1000000000000_example.pdf').once

        Net::SFTP.should_receive(:start).with('api.onlinebrief24.de', params[:login], :password => params[:password]) { sftp }

        subject.upload!(filehandle).should eql('1000000000000_example.pdf')
      end
    end

    describe 'with a filename' do
      it 'should upload the letter with the correct remote filename' do
        sftp = double('sftp')
        sftp.should_receive(:upload!).with(local_path, '/upload/api/1000000000000_example.pdf').once

        Net::SFTP.should_receive(:start).with('api.onlinebrief24.de', params[:login], :password => params[:password]) { sftp }

        subject.upload!(local_path).should eql('1000000000000_example.pdf')
      end
      it 'should upload the letter with the correct remote filename with options' do
        sftp = double('sftp')
        sftp.should_receive(:upload!).with(local_path, '/upload/api/0100000000000_example.pdf').once

        Net::SFTP.should_receive(:start).with('api.onlinebrief24.de', params[:login], :password => params[:password]) { sftp }

        subject.upload!(local_path, :duplex => true, :color => false).should eql('0100000000000_example.pdf')
      end
    end
  end
end

