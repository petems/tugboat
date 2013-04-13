# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tugboat/version'

Gem::Specification.new do |gem|
  gem.name          = "tugboat"
  gem.version       = Tugboat::VERSION
  gem.authors       = ["Jack Pearkes"]
  gem.email         = ["jackpearkes@gmail.com"]
  gem.description   = %q{A command line tool for interacting with your DigitalOcean droplets.}
  gem.summary       = %q{A command line tool for interacting with your DigitalOcean droplets.}
  gem.homepage      = "https://github.com/pearkes/tugboat"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "thor", "~> 0.18.1"
  gem.add_dependency "digital_ocean", "~> 1.0.1"
  gem.add_dependency "middleware" , "~> 0.1.0"
  gem.add_dependency "activesupport"
end
