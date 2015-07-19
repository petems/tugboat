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

  gem.files                 = `git ls-files`.split($/)
  gem.executables           = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths         = ["lib"]
  gem.required_ruby_version = ">= 1.9.2"

  gem.add_dependency "thor", "~> 0.18.1"
  gem.add_dependency "barge", "~> 0.10.0"
  gem.add_dependency "middleware" , "~> 0.1.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec-core", "~> 2.14.0"
  gem.add_development_dependency "rspec-expectations", "~> 2.14.0"
  gem.add_development_dependency "rspec-mocks", "~> 2.14.0"
  gem.add_development_dependency "webmock", "~> 1.11.0"
  gem.add_development_dependency "coveralls", "~> 0.6.7"
  gem.add_development_dependency 'aruba', '~> 0.6.2'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'vcr'

  gem.post_install_message = '***************************************'
  gem.post_install_message = '   .  o ..                            '
  gem.post_install_message = ' o . o o.o                            '
  gem.post_install_message = '      ...oo                           '
  gem.post_install_message = '        __[]__                        '
  gem.post_install_message = '     __|_o_o_o\__                     '
  gem.post_install_message = '     \""""""""""/                     '
  gem.post_install_message = '      \. ..  . /                      '
  gem.post_install_message = ' ^^^^^^^^^^^^^^^^^^^^                 '
  gem.post_install_message = ' This is an Alpha release of the      '
  gem.post_install_message = ' Tugboat 2.0.0 version                '
  gem.post_install_message = ' It is very much an alpha and unstable'
  gem.post_install_message = '                                      '
  gem.post_install_message = ' You\'ll need to update your API Keys '
  gem.post_install_message = ' For more details see here:           '
  gem.post_install_message = ' https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2'
  gem.post_install_message = ' Or downgrade to a version < 2.0.0:   '
  gem.post_install_message = ' `gem install tugboat -v 1.0.0        '
  gem.post_install_message = '***************************************'

end
