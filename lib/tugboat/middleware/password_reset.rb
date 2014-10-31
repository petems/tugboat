module Tugboat
  module Middleware
    class PasswordReset < Base
      def call(env)
        ocean = env['barge']

        say "Queuing password reset for #{env["droplet_id"]} #{env["droplet_name"]}...", nil, false
        res = ocean.droplets.password_reset env["droplet_id"]

        if res.status == "ERROR"
          say res.error_message, :red
          exit 1
        end

        say "done", :green
        say "Your new root password will be emailed to you"

        @app.call(env)
      end
    end
  end
end

