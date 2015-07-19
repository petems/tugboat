module Tugboat
  module Middleware
    class RebuildDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing rebuild for droplet #{env["droplet_id"]} #{env["droplet_name"]} with image #{env["image_id"]} #{env["image_name"]}...", nil, false

        response = ocean.droplets.rebuild env["droplet_id"],
                                     :image_id => env["image_id"]

        if response.success?
          say "done", :green
        else
          say "Failed to rebuild Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end