require 'digital_ocean'
module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          env["ocean"]  = DigitalOcean::API.new \
                             :client_id => env["config"].client_key,
                             :api_key   => env["config"].api_key

          @app.call(env)
        end
    end
  end
end

