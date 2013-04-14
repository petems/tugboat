module Tugboat
  module Middleware
    class RestartDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queuing restart for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false

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

