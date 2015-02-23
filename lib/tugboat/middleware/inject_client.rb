require 'barge'

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          @access_token = env["config"].access_token

          env['barge'] = Barge::Client.new(:access_token => @access_token)

          @app.call(env)
        end
    end
  end
end

