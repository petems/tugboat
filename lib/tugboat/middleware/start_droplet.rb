module Tugboat
  module Middleware
    class StartDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing start for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
        req = ocean.droplets.power_on env["droplet_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end
