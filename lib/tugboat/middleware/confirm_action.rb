module Tugboat
  module Middleware
    class ConfirmAction < Base
      def call(env)

        if !env["user_confirm_action"]
          response = yes? "Warning! Potentially destructive action. Please confirm [y/n]:"

          if !response
            say "Aborted due to user request.", :red
            # Quit
            return
          end

        end

        @app.call(env)
      end
    end
  end
end

