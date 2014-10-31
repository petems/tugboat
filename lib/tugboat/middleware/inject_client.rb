require 'barge'
require File.expand_path('../authentication_middleware', __FILE__)
require File.expand_path('../custom_logger', __FILE__)

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          @client_id = env["config"].access_token

          env['barge'] = Barge::Client.new(access_token: @client_id)

          @app.call(env)
        end
    end
  end
end

