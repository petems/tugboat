require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  coverage_dir('coverage/')
end

require 'tugboat'
require 'webmock/rspec'
require 'barge'
require "shared/environment"

RSpec.configure do |config|
  # Pretty tests
  config.color = true

  config.order = :random
end

def project_path
  File.expand_path("../..", __FILE__)
end

def fixture(fixture_name, format='json')
  File.new(project_path + "/spec/fixtures/#{fixture_name}.#{format}")
end

ENV["TUGBOAT_CONFIG_PATH"] = project_path + "/tmp/tugboat"
