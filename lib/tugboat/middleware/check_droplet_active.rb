module Tugboat
  module Middleware
    # Check if the droplet in the environment is active
    class CheckDropletActive < Base
      def call(env)

        if env["droplet_status"] != "active"
          say "Droplet must be on for this operation to be successful.", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

