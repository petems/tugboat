module Tugboat
  module Middleware
    class StartDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing start for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
        response = ocean.droplet.power_on env["droplet_id"]

        unless response.success?
          say "Failed to halt Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
