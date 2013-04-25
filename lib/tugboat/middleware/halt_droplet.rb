module Tugboat
  module Middleware
    class HaltDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing shutdown for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        req = ocean.droplets.shutdown env["droplet_id"]

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

