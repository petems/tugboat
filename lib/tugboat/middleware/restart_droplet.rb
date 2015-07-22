module Tugboat
  module Middleware
    class RestartDroplet < Base
      def call(env)
        ocean = env['barge']

        response = if env["user_droplet_hard"]
          say "Queuing hard restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet.power_cycle env["droplet_id"]
        else
          say "Queuing restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet.reboot env["droplet_id"]
        end

        unless response.success?
          say "Failed to destroy Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

