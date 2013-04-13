require 'thor/error'

module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckAndInjectConfiguration < Base
      def call(env)
        config = Tugboat::Configuration.instance

        # Check to see if the config exists as it should, if not, raise an error.
        if !config.data || !config.api_key || !config.client_key
          raise Thor::Error.new "You must run `tugboat authorize` in order to access DigtalOcean."
        end

        env["config"] = config

        @app.call(env)
      end
    end
  end
end

