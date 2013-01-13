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
      @fingerprint = opts[:fingerprint] || '5b:d1:29:17:cb:5e:17:b9:e2:29:4e:1e:aa:c7:d9:b2'
    end


    def upload!(letter)
      raise ArgumentError unless letter.is_a?(Onlinebrief24::Letter)

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
