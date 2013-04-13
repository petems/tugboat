module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        say "Checking configuration..."
        @app.call(env)
      end
    end
  end
end

