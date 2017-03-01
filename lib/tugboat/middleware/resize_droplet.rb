module Tugboat
  module Middleware
    class ResizeDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing resize for #{env['droplet_id']} #{env['droplet_name']}...", nil, false

        response = ocean.droplet.resize env['droplet_id'],
                                        size: env['user_droplet_size']

        if response.success?
          say 'Resize complete!', :green
        else
          say "Failed to resize Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
