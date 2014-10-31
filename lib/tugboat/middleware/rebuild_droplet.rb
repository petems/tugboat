module Tugboat
  module Middleware
    class RebuildDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing rebuild for droplet #{env["droplet_id"]} #{env["droplet_name"]} with image #{env["image_id"]} #{env["image_name"]}...", nil, false

        req = ocean.droplets.rebuild env["droplet_id"],
                                     :image_id => env["image_id"]

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end