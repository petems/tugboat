module Tugboat
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)
        say "Note: You can get this stuff at digitalocean.com/api_access", :yellow
        say
        client_key = ask "Enter your client key:"
        secret_key = ask "Enter your API key:"
        say secret_key, client_key
        say
        say "Checking..."
        say "Succesfully authenticated.", :green
        @app.call(env)
      end
    end
  end
end

