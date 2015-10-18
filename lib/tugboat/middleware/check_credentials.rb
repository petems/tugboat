require 'thor'

module Tugboat
  module Middleware
    # Check if the client can connect to the ocean
    class CheckCredentials < Base
      def call(env)
        # We use a harmless API call to check if the authentication will
        # work.
        begin
          env['barge'].droplets.list
        rescue Faraday::Error::ClientError => e
          say "Authentication with DigitalOcean failed. Run `tugboat authorize`", :red
          exit 1
        end

        say "Authentication with DigitalOcean was successful.", :green

        @app.call(env)
      end
    end
  end
end

