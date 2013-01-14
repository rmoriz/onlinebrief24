require 'net/sftp'

module Onlinebrief24
  class Client
    attr_accessor :login, :password, :server, :port, :upload_dir, :fingerprint

    def initialize(opts = {})
      @login       = opts[:login]
      @password    = opts[:password]
      @server      = opts[:server]      || 'api.onlinebrief24.de'
      @port        = opts[:port]        || 22
      @upload_dir  = opts[:upload_dir]  || '/upload/api'
    end

    def upload!(letter_or_file_handle_or_filename, options = {})

      if letter_or_file_handle_or_filename.is_a?(File) || letter_or_file_handle_or_filename.is_a?(String)
        letter = Letter.new(letter_or_file_handle_or_filename, options)
      elsif letter_or_file_handle_or_filename.is_a?(Onlinebrief24::Letter)
        letter = letter_or_file_handle_or_filename
      else
        raise ArgumentError, letter_or_file_handle_or_filename.class
      end

      letter.valid?

      connection.upload!(letter.local_path, abs_remote_path(letter.remote_filename))

      letter.remote_filename
    end

    def connection
      return @connection if @connection and @connection.open?

      @connection = Net::SFTP.start(@server, @login, :password => @password)
    end
    alias_method :connect, :connection

    def disconnect
      @connection.close if @connection and @connection.open?
    end

    def abs_remote_path(filename)
      @upload_dir + '/' + filename
    end

  end
end
