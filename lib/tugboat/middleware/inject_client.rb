require 'barge'

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
        def call(env)
          token = env["config"].token

          # Put this barge into the env for use later
          env["client"] = Barge::Client.new(access_token: token)

          @app.call(env)
        end
    end
  end
end

