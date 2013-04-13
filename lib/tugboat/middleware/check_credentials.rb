module Tugboat
  module Middleware
    # Check if the client can connect to DO
    class CheckCredentials < Base
      def call(env)
        say "Checking credentials..."
        @app.call(env)
      end
    end
  end
end

