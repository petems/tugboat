module Tugboat
  module Middleware
    # Check if the droplet in the environment is active
    class CheckSnapshotParameters < Base
      def call(env)
        unless env['user_droplet_id'] || env['user_droplet_name'] || env['user_droplet_fuzzy_name']
          say 'You must provide a snapshot name followed by the droplet\'s name.', :red
          say "For example: `tugboat snapshot #{env['user_snapshot_name']} example-node.com`", :green
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
