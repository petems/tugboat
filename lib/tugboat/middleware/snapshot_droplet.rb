module Tugboat
  module Middleware
    class SnapshotDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing snapshot '#{env["user_snapshot_name"]}' for #{env["droplet_id"]}...", nil, false

        req = ocean.droplets.snapshot env["droplet_id"],
                                :name => env["user_snapshot_name"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          return
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

