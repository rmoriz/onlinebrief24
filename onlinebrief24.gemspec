# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onlinebrief24/version'

Gem::Specification.new do |gem|
  gem.name          = "onlinebrief24"
  gem.version       = Onlinebrief24::VERSION
  gem.authors       = ["Roland Moriz"]
  gem.email         = ["roland@moriz.de"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'net-sftp', '~> 2.0'
  gem.add_development_dependency "rspec", '~> 2.0'
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"
end
