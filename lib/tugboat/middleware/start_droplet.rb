module Tugboat
  module Middleware
    class StartDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing start for #{env['droplet_id']} #{env['droplet_name']}...", nil, false
        response = ocean.droplet.power_on env['droplet_id']

        if response.success?
          say 'Start complete!', :green
        else
          say "Failed to start Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
