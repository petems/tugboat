# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tugboat/version'

Gem::Specification.new do |gem|
  gem.name          = 'tugboat'
  gem.version       = Tugboat::VERSION
  gem.authors       = ['Jack Pearkes', 'Peter Souter', 'Ørjan Blom']
  gem.email         = ['jackpearkes@gmail.com']
  gem.description   = 'A command line tool for interacting with your DigitalOcean droplets.'
  gem.summary       = 'A command line tool for interacting with your DigitalOcean droplets.'
  gem.homepage      = 'https://github.com/pearkes/tugboat'

  gem.files                 = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables           = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths         = ['lib']
  gem.required_ruby_version = '>= 1.9.2'

  gem.add_dependency 'thor', '0.18.1'
  gem.add_dependency 'barge', '0.12.0'
  gem.add_dependency 'droplet_kit', '2.0.1'
  gem.add_dependency 'middleware', '0.1.0'
  # Update back to faraday_middleware when https://github.com/lostisland/faraday_middleware/pull/157 merged
  gem.add_dependency 'faraday_middleware_safeyaml', '0.12.pre.safeyaml'
  gem.add_dependency 'faraday', '0.9.2'
  gem.add_dependency 'hashie', '3.5.5'
  gem.add_dependency 'activesupport', '4.1.11'

  gem.add_development_dependency 'rake', '< 11.0'
  gem.add_development_dependency 'rspec-core', '~> 2.14.0'
  gem.add_development_dependency 'rspec-expectations', '~> 2.14.0'
  gem.add_development_dependency 'rspec-mocks', '~> 2.14.0'
  gem.add_development_dependency 'webmock', '~> 1.11.0'
  gem.add_development_dependency 'simplecov', '0.10'
  gem.add_development_dependency 'simplecov-console', '0.2.0'
  gem.add_development_dependency 'coveralls', '~> 0.6.7'
  gem.add_development_dependency 'aruba', '0.7.4'
  gem.add_development_dependency 'pry', '0.10.4'
  gem.add_development_dependency 'rb-readline', '0.5.3'
  gem.add_development_dependency 'vcr', '2.9.3'
  gem.add_development_dependency 'cucumber', '2.0.2'
  gem.add_development_dependency 'rubocop', '0.47.1'
  gem.add_development_dependency 'rubocop-rspec', '1.5.0'
  gem.add_development_dependency 'license_finder'

  gem.post_install_message = '***************************************'
  gem.post_install_message = '   .  o ..                            '
  gem.post_install_message = ' o . o o.o                            '
  gem.post_install_message = '      ...oo                           '
  gem.post_install_message = '        __[]__                        '
  gem.post_install_message = '     __|_o_o_o\__                     '
  gem.post_install_message = '     \""""""""""/                     '
  gem.post_install_message = '      \. ..  . /                      '
  gem.post_install_message = ' ^^^^^^^^^^^^^^^^^^^^                 '
  gem.post_install_message = " Tugboat #{Tugboat::VERSION} version  "
  gem.post_install_message = '                                      '
  gem.post_install_message = ' If you updated from Tugboat 1.0      '
  gem.post_install_message = ' You will need to update your API Keys'
  gem.post_install_message = ' For more details see here:           '
  gem.post_install_message = ' https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2'
  gem.post_install_message = ' The Tugboat 1.0 API EOL as of November 9th 2015'
  gem.post_install_message = ' Tugboat < 1.0.0 will no longer work from that time'
  gem.post_install_message = '***************************************'
end
