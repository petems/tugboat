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
        timeout = env['config'].timeout

        env['barge'] = Barge::Client.new(access_token: @access_token)
        if not env['barge'].nil?
          env['barge'].request_options[:timeout] = timeout
          env['barge'].request_options[:open_timeout] = timeout
        end
        env['droplet_kit'] = DropletKit::Client.new(access_token: @access_token)

        env['barge'].faraday.use CustomLogger if ENV['DEBUG']
        env['droplet_kit'].connection.use CustomLogger if ENV['DEBUG']

        @app.call(env)
      end
    end
  end
end
