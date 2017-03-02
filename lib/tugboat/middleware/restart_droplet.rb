module Tugboat
  module Middleware
    class RestartDroplet < Base
      def call(env)
        ocean = env['barge']

        response = restart_droplet(env['user_droplet_hard'], ocean, env['droplet_id'], env['droplet_name'])

        if response.success?
          say 'Restart complete!', :green
        else
          say "Failed to restart Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
