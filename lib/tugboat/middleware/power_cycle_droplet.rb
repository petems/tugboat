module Tugboat
  module Middleware
    class PowerCycleDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing power cycle for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        res = ocean.droplets.power_cycle env["droplet_id"]

        if res.status == "ERROR"
          say res.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end
