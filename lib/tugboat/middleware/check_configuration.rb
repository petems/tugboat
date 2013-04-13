require 'thor/error'

module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        config = env["config"]

        if !config || !config.data || !config.api_key || !config.client_key
          say "You must run `tugboat authorize` in order to connect to DigitalOcean", :red
        end

        @app.call(env)
      end
    end
  end
end

