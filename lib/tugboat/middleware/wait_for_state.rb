module Tugboat
  module Middleware
    class WaitForState < Base
      def call(env)
        ocean = env['barge']

        say "Waiting for droplet to become #{env["user_droplet_desired_state"]}.", nil, false

        start_time = Time.now

        req = ocean.droplets.show env["droplet_id"]

        say ".", nil, false

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        while req.droplet.status != env["user_droplet_desired_state"] do
          sleep 2
          req = ocean.droplets.show env["droplet_id"]
          say ".", nil, false
        end

        total_time = (Time.now - start_time).to_i

        say "done#{CLEAR} (#{total_time}s)", :green

        @app.call(env)
      end
    end
  end
end

