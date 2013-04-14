module Tugboat
  module Middleware
    class ConfirmAction < Base
      def call(env)
        response = yes? "Warning! Potentially destructive action. Please confirm [y/n]:"

        if !response
          say "Aborted due to user request.", :red
          # Quit
          return
        end

        @app.call(env)
      end
    end
  end
end

