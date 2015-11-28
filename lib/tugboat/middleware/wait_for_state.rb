module Tugboat
  module Middleware
    class WaitForState < Base
      def call(env)
        ocean = env['barge']

        say "Waiting for droplet to become #{env["user_droplet_desired_state"]}.", nil, false

        wait_for_state(env["droplet_id"],env["user_droplet_desired_state"],ocean)

        @app.call(env)
      end
    end
  end
end

