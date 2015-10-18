module Tugboat
  module Middleware
    class SnapshotDroplet < Base
      def call(env)
        ocean = env['barge']
        # Right now, the digital ocean API doesn't return an error
        # when your droplet is not powered off and you try to snapshot.
        # This is a temporary measure to let the user know.
        say "Warning: Droplet must be in a powered off state for snapshot to be successful", :yellow

        say "Queuing snapshot '#{env["user_snapshot_name"]}' for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        req = ocean.droplets.snapshot env["droplet_id"],
                                :name => env["user_snapshot_name"]

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

