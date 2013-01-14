# Onlinebrief24

[![Build Status](https://travis-ci.org/rmoriz/onlinebrief24.png)](https://travis-ci.org/rmoriz/onlinebrief24)

This gem is only interesting for users that use the German letter outbound service Onlinebrief24.de. This gem wraps the required workflow to upload a PDF to Onlinebrief24's servers. Onlinebrief24 then prints and mails the letters via snail mail. As this service is only available to German customers, the following documentation is available in German language only.

## Requirements

Ruby 1.9.2 oder neuer.

## Installation

Über Bundler in einem Gemfile:

    gem 'onlinebrief24'

und dann:

    $ bundle

oder global mit:

    $ gem install onlinebrief24

## Anwendungs-Beispiele

#### Kurzform
```ruby
  require 'onlinebrief24'
  
  c = Onlinebrief24::Client.new :login => 'email@example.com', :password => '123456'
  
  c.upload! '/tmp/filename1.pdf', :duplex     => true,       :color        => false
  c.upload! '/tmp/filename2.pdf', :registered => :insertion, :envelope     => :c4
  c.upload! '/tmp/filename3.pdf', :registered => :standard,  :distribution => :international
  
  c.disconnect
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright

Licensed under the MIT license.

Copyright (C) 2013 Moriz GmbH, https://moriz.de/
