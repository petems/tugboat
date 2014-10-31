module Tugboat
  module Middleware
    class RestartDroplet < Base
      def call(env)
        ocean = env['barge']

        req = if env["user_droplet_hard"]
          say "Queuing hard restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplets.power_cycle env["droplet_id"]
        else
          say "Queuing restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplets.reboot env["droplet_id"]
        end

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

