require 'tugboat'

RSpec.configure do |config|
  # Pretty tests
  config.color_enabled = true
end

def project_path
  File.expand_path("../..", __FILE__)
end

