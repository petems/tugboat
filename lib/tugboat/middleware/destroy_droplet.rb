module Tugboat
  module Middleware
    class DestroyDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing destroy for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        response = ocean.droplet.destroy env["droplet_id"]

        if response.success?
          say "done", :green
        else
          say "Failed to destroy Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

