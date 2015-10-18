module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        config = env["config"]

        if !config || !config.data || !config.access_token
          say "You must run `tugboat authorize` in order to connect to DigitalOcean", :red
          exit 1
        end

        # If the user passes the global `-q/--quiet` flag, redirect
        # stdout
        if env["user_quiet"]
          $stdout = File.new('/dev/null', 'w')
        end

        @app.call(env)
      end
    end
  end
end

