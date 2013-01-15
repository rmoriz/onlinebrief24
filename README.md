# Onlinebrief24

[![Build Status](https://travis-ci.org/rmoriz/onlinebrief24.png)](https://travis-ci.org/rmoriz/onlinebrief24)

This gem is only interesting for users that use the German letter outbound service <a href="http://www.onlinebrief24.de/">Onlinebrief24.de</a>. This gem wraps the required workflow to upload a PDF to Onlinebrief24's servers. Onlinebrief24 then prints and mails the letters via snail mail. As this service is only available to German customers, the following documentation is available in German language only.

## Voraussetzung

Ruby 1.9.2 oder neuer.

## Installation

Über Bundler im Gemfile hinzufügen:

```ruby
gem 'onlinebrief24'
```

…dann auf der Shell Bundler das Gem installieren lassen:

```shell
$ bundle
```

…oder global mit:

```shell
$ gem install onlinebrief24
```

## Beispiele

### Kurzform
```ruby
require 'onlinebrief24'

c = Onlinebrief24::Client.new :login => 'email@example.com', :password => '123456'

c.upload! '/tmp/filename1.pdf', :duplex     => true,       :color        => false
c.upload! '/tmp/filename2.pdf', :registered => :insertion, :envelope     => :c4
c.upload! '/tmp/filename3.pdf', :registered => :standard,  :distribution => :international

c.disconnect
```

### Block

```ruby
require 'onlinebrief24'

Onlinebrief24::Client.new(:login => 'email@example.com', :password => '123456') do |client|
  client.upload! '/tmp/filename1.pdf', :duplex     => true,       :color        => false
  client.upload! '/tmp/filename2.pdf', :registered => :insertion, :envelope     => :c4
  client.upload! '/tmp/filename3.pdf', :registered => :standard,  :distribution => :international
end
```

### Optionen für Brief

<table width="100%">
  <tr>
    <th>Option</th>
    <th>Werte</th>
    <th>Vorbelegung</th>
    <th>Beschreibung</th>
  </tr>
  <tr>
    <td>
      <strong>:color</strong>
    </td>
    <td>
      <ul>
        <li>true</li>
        <li>false</li>
      </ul>
    </td>
    <td>
      false
    </td>
    <td>
      Farbdruck ja/nein
    </td>
  </tr>
    
  <tr>
    <td>
      <strong>:duplex</strong>
    </td>
    <td>
      <ul>
        <li>true</li>
        <li>false</li>
      </ul>
    </td>
    <td>
      false
    </td>
    <td>
      Duplexdruck ja/nein
    </td>
  </tr>
  
  <tr>
    <td>
      <strong>:envelope</strong>
    </td>
    <td>
      <ul>
        <li>:din_lang</li>
        <li>:c4</li>
      </ul>
    </td>
    <td>
      :din_lang
    </td>
    <td>
      Umschlagformat. DIN lang oder C4.
    </td>
  </tr>

  <tr>
    <td>
      <strong>:distribution</strong>
    </td>
    <td>
      <ul>
        <li>:auto</li>
        <li>:national/li>
        <li>:international</li>
      </ul>
    </td>
    <td>
      :auto
    </td>
    <td>
      Versandzone. Automatisch, National, International
    </td>
  </tr>

  <tr>
    <td>
      <strong>:registered</strong>
    </td>
    <td>
      <ul>
        <li>:none</li>
        <li>:insertion</li>
        <li>:standard</li>
        <li>:personal</li>
      </ul>
    </td>
    <td>
      :none
    </td>
    <td>
      Einschreiben: Nein, Einwurf-Einschreiben, Standard-Einschreiben, Einschreiben eigenhändig
    </td>
  </tr>
  

</table>


### Hinweis

* PDF-Dateien müssen unter Beachtung der Vorgaben von Onlinebrief24 erstellt und formatiert werden:
  http://www.onlinebrief24.de/software/infodokumente.htm
* Dieses gem benutzt die SFTP-Schnittstelle:
  http://www.onlinebrief24.de/software/sftp-schnittstelle.htm

### Ausprobieren / Keine Funktionsgarantie!

Onlinebrief24 räumt jedem Neukunden ein Guthaben von 5 EUR ein. Es wird empfohlen die Benutzung dieses rubygems damit zu testen. Die vorhandenen Tests (RSpec) im ```spec```-Verzeichnis können dies nicht ersetzen!


### Fehler? Probleme? Patches?

Bitte Fehler, Probeme und Patches über Github Issues bzw Pull-Requests einreichen.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Hinweis

Dies ist ein unabhängiges OpenSource-Projekt und kein offizielles Produkt von Onlinebrief24.de.

## Copyright

Licensed under the MIT license.

Copyright (C) 2013 Moriz GmbH, https://moriz.de/
