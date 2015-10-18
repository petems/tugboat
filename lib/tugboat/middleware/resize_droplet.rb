module Tugboat
  module Middleware
    class ResizeDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queuing resize for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

        res = ocean.droplets.resize env["droplet_id"],
                                    :size_id => env["user_droplet_size"]

        if res.status == "ERROR"
          say "#{res.status}: #{res.error_message}", :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

