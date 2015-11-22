require 'thor'

module Tugboat
  module Middleware
    # Check if the client can connect to the ocean
    class CheckCredentials < Base
      def call(env)
        # We use a harmless API call to check if the authentication will
        # work.
        begin
          response = env['barge'].droplet.all({:per_page =>'1', :page =>'1'})
        rescue Faraday::ClientError => e
          say "Authentication with DigitalOcean failed at an early stage"
          say "Error was: #{e}"
          exit 1
        end

        unless response.success?
          say "Failed to connect to DigitalOcean. Reason given from API: #{response.id} - #{response.message}", :red
          exit 1
        else
          say "Authentication with DigitalOcean was successful.", :green
        end

        @app.call(env)
      end
    end
  end
end

