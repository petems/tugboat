module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        config = env['config']

        if !config || !config.data || !config.access_token
          say 'You must run `tugboat authorize` in order to connect to DigitalOcean', :red
          exit 1
        end

        # If the user passes the global `-q/--quiet` flag, redirect
        # stdout
        $stdout = File.new('/dev/null', 'w') if env['user_quiet']

        @app.call(env)
      end
    end
  end
end
