module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class RestartDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing restart for #{env["droplet_id"]}...", nil, false

        req = ocean.droplets.reboot env["droplet_id"]

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

