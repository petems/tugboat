module Tugboat
  module Middleware
    class HaltDroplet < Base
      def call(env)
        ocean = env['barge']

        response = if env["user_droplet_hard"]
          say "Queuing hard shutdown for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet.power_off env["droplet_id"]
        else
          say "Queuing shutdown for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
          ocean.droplet.shutdown env["droplet_id"]
        end

        if response.success?
          say "done", :green
        else
          say "Failed to halt Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end