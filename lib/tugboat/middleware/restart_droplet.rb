require 'thor/error'

module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class RestartDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing restart for #{env["droplet_id"]}...", nil, false

        ocean.droplets.reboot env["droplet_id"]

        say "done", :green

        @app.call(env)
      end
    end
  end
end

