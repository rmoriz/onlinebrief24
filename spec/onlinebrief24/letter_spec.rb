require 'spec_helper'

describe Onlinebrief24::Letter do
  subject {
    Onlinebrief24::Letter.new file_or_filename, options
  }

  let(:options) { {} }
  let(:filename) { File.expand_path('../../example_files/example.pdf', __FILE__) }

  describe '#initialize' do
    context 'without a filename' do
      subject { Onlinebrief24::Letter.new }

      it 'should raise an error' do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'with a filename' do
      let(:file_or_filename) { filename }

      it { should be_instance_of(Onlinebrief24::Letter) }

      its(:local_path){ should eql(filename) }
      its(:local_filename){ should eql(File.basename(filename)) }
    end

    context 'with a file handle' do
      let(:file_or_filename) { File.open(filename) }

      it { should be_instance_of(Onlinebrief24::Letter) }

      its(:local_path){ should eql(filename) }
      its(:local_filename){ should eql(File.basename(filename)) }
    end
  end


  describe 'settings' do
    let(:file_or_filename) { filename }

    describe '#duplex?' do
      context 'default' do
        its(:duplex) { should be_false }
      end
      context 'disabled' do
        let(:options) { { :duplex => false } }
        its(:duplex) { should be_false }
      end
      context 'enabled' do
        let(:options) { { :duplex => true } }
        its(:duplex) { should be_true }
      end
    end

    describe '#color?' do
      context 'default' do
        its(:color) { should be_true }
      end
      context 'disabled' do
        let(:options) { { :color => false } }
        its(:color) { should be_false }
      end
      context 'enabled' do
        let(:options) { { :color => true } }
        its(:color) { should be_true }
      end
    end

    describe '#envelope?' do
      context 'default' do
        its(:envelope) { should eql(:din_lang) }
      end
      context 'DIN Lang' do
        let(:options) { { :envelope => :din_lang } }
        its(:envelope) { should eql(:din_lang) }
      end
      context 'C4' do
        let(:options) { { :envelope => :c4 } }
        its(:envelope) { should eql(:c4) }
      end
      context 'invalid' do
        let(:options) { { :envelope => :A0 } }
        it { expect { subject }.to raise_error(Onlinebrief24::InvalidLetterAttributeValueError) }
      end
    end

    describe '#distribution?' do
      context 'default' do
        its(:distribution) { should eql(:auto) }
      end
      context 'national' do
        let(:options) { { :distribution => :national } }
        its(:distribution) { should eql(:national) }
      end
      context 'invalid' do
        let(:options) { { :distribution => :warp } }
        it { expect { subject }.to raise_error(Onlinebrief24::InvalidLetterAttributeValueError) }
      end
    end

    describe 'remote_filename' do
      context 'default' do
        its(:remote_filename) { should eql('1000000000000_example.pdf') }
      end

      context 'default with cost center' do
        let(:options) { { :cost_center => 'trash_and_law' } }
        its(:remote_filename) { should eql('1000000000000_example#trash_and_law#.pdf') }
      end

      describe 'color duplex with c4 envelope' do
        let(:options) { { :color => true, :duplex => true, :envelope => :c4 } }
        its(:remote_filename) { should eql('1110000000000_example.pdf') }
      end

      context 'distribution' do
        describe 'auto' do
          let(:options) { { :distribution => :auto } }
          its(:remote_filename) { should eql('1000000000000_example.pdf') }
        end
        describe 'national' do
          let(:options) { { :distribution => :national } }
          its(:remote_filename) { should eql('1001000000000_example.pdf') }
        end
        describe 'international' do
          let(:options) { { :distribution => :international } }
          its(:remote_filename) { should eql('1003000000000_example.pdf') }
        end
      end

      context 'registered (Einschreiben)' do
        describe 'none' do
          let(:options) { { :registered => :none} }
          its(:remote_filename) { should eql('1000000000000_example.pdf') }
        end
        describe 'insertion (Einwurf)' do
          let(:options) { { :registered => :insertion } }
          its(:remote_filename) { should eql('1000100000000_example.pdf') }
        end
        describe 'standard' do
          let(:options) { { :registered => :standard } }
          its(:remote_filename) { should eql('1000200000000_example.pdf') }
        end
        describe 'personal (eigenhaendig)' do
          let(:options) { { :registered => :personal } }
          its(:remote_filename) { should eql('1000300000000_example.pdf') }
        end
      end
    end
  end
end
