module Tugboat
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)
        say "Note: You can get this information from digitalocean.com/api_access", :yellow
        say
        client = ask "Enter your client key:"
        api = ask "Enter your API key:"

        # Write the config file.
        env['config'].create_config_file(client, api)

        @app.call(env)
      end
    end
  end
end

