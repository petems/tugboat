require 'barge'
require 'droplet_kit'
require File.expand_path('../custom_logger', __FILE__)

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
      def call(env)
        # Sets the digital ocean client into the environment for use
        # later.
        @access_token = env['config'].access_token
        config_timeout = env['config'].timeout

        env['barge'] = Barge::Client.new(access_token: @access_token,
                                         timeout: config_timeout,
                                         open_timeout: config_timeout)

        env['droplet_kit'] = DropletKit::Client.new(access_token: @access_token)

        env['droplet_kit'].connection.options.timeout       = config_timeout.to_i
        env['droplet_kit'].connection.options.open_timeout  = config_timeout.to_i

        env['barge'].faraday.use CustomLogger if ENV['DEBUG']
        env['droplet_kit'].connection.use CustomLogger if ENV['DEBUG']

        env['droplet_kit'].connection

        @app.call(env)
      end
    end
  end
end
