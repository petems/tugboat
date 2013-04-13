module Tugboat
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)
        say "Note: You can get this information from digitalocean.com/api_access", :yellow
        say
        ask "Enter your client key:"
        ask "Enter your API key:"
        @app.call(env)
      end
    end
  end
end

