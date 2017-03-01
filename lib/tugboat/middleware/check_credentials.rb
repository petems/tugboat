require 'thor'

module Tugboat
  module Middleware
    # Check if the client can connect to the ocean
    class CheckCredentials < Base
      def call(env)
        # We use a harmless API call to check if the authentication will
        # work.
        verify_credentials(env['barge'], true)

        @app.call(env)
      end
    end
  end
end
