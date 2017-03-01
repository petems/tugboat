module Tugboat
  module Middleware
    class RebuildDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing rebuild for droplet #{env['droplet_id']} #{env['droplet_name']} with image #{env['image_id']} #{env['image_name']}...", nil, false

        response = ocean.droplet.rebuild env['droplet_id'],
                                         image: env['image_id']

        if response.success?
          say 'Rebuild complete', :green
        else
          say "Failed to rebuild Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
