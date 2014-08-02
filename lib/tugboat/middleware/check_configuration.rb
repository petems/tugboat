module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class CheckConfiguration < Base
      def call(env)
        config = env["config"]
        ui = env["ui"]

        if !config || !config.data || !config.token
          ui.say("You must run `tugboat authorize` in order to connect to DigitalOcean", :fail)
          ui.fail
        end

        @app.call(env)
      end
    end
  end
end

