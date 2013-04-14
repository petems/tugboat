module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class HaltDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing shutdown for #{env["droplet_id"]}...", nil, false

        ocean.droplets.shutdown env["droplet_id"]

        say "done", :green

        @app.call(env)
      end
    end
  end
end

