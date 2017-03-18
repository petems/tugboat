require 'tugboat/cli'
require 'tugboat/config'
require 'tugboat/version'
require 'json'

# TODO: do this properly
# See: https://github.com/intridea/hashie/issues/394
require 'hashie'
require 'hashie/logger'
Hashie.logger = Logger.new(nil)

module Tugboat
end
