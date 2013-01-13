module Onlinebrief24
  class InvalidLetterAttributeValueError < StandardError; end

  class Letter
    attr_accessor :local_path, :local_filename, :color, :duplex, :envelope, :distribution, :registered, :cost_center

    ENVELOPE_FORMATS     = [ :din_lang, :c4 ]
    DISTRIBUTION_FORMATS = [ :auto, :national, :international ]
    REGISTERED_OPTIONS   = [ :none, :insertion, :standard, :personal ]

    def initialize(file_or_filename, options = {})
      @local_path     = File.expand_path(file_or_filename)
      @local_filename = File.basename(@local_path)

      defaults.merge(options).each_pair do |setting, value|
        send("#{setting}=", value)
      end

      validate_settings
    end

    def defaults
      {
        :color        => true,
        :duplex       => false,
        :envelope     => :din_lang,
        :distribution => :auto,
        :registered   => :none
      }
    end

    def remote_filename
      rf = '0000000000000' + '_' + with_cost_center(@local_filename)

      case @color
      when true
        rf[0] = "1"
      else
        rf[0] = "0"
      end

      case @duplex
      when true
        rf[1] = "1"
      else
        rf[1] = "0"
      end

      case @envelope
      when :c4
        rf[2] = "1"
      else
        rf[2] = "0"
      end

      case @distribution
      when :auto
        rf[3] = "0"
      when :national
        rf[3] = "1"
      when :international
        rf[3] = "3"
      end

      case @registered
      when :none
        rf[4] = "0"
      when :insertion
        rf[4] = "1"
      when :standard
        rf[4] = "2"
      when :personal
        rf[4] = "3"
      end

      rf
    end

    private

    def with_cost_center(filename)
      filename.gsub!(/\.pdf/, "##{@cost_center}#.pdf") if @cost_center
      filename
    end

    def validate_settings
      unless ENVELOPE_FORMATS.include? @envelope
        raise InvalidLetterAttributeValueError, ':envelope value needs to be within: ' + ENVELOPE_FORMATS.join(',') + ' - value was: ' + @envelope.inspect
      end

      unless DISTRIBUTION_FORMATS.include? @distribution
        raise InvalidLetterAttributeValueError, ':distribution value needs to be within: ' + DISTRIBUTION_FORMATS.join(',') + '- value was: ' + @distribution.inspect
      end

      unless REGISTERED_OPTIONS.include? @registered
        raise InvalidLetterAttributeValueError, ':registered value needs to be within: ' + REGISTERED_OPTIONS.join(',') + '- value was: ' + @registered.inspect
      end
    end
  end
end
