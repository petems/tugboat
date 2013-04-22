require 'tugboat'
require 'webmock/rspec'

RSpec.configure do |config|
  # Pretty tests
  config.color_enabled = true
end

def project_path
  File.expand_path("../..", __FILE__)
end

def fixture(fixture_name)
  File.new(project_path + "/spec/fixtures/#{fixture_name}.json")
end
