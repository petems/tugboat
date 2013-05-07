module Tugboat
  module Middleware
    # Check if the droplet in the environment is inactive, or "off"
    class CheckDropletInactive < Base
      def call(env)

        if env["droplet_status"] != "off"
          say "Droplet must be off for this operation to be successful.", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

