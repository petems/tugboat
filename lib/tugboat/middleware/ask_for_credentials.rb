module Tugboat
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)
        say "Note: You can get this information from digitalocean.com/api_access", :yellow
        say
        client_key = ask "Enter your client key:"
        api_key = ask "Enter your API key:"
        ssh_key_path = ask "Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa):"
        ssh_user = ask "Enter your SSH user (optional, defaults to #{ENV['USER']}):"
        ssh_port = ask "Enter your SSH port number (optional, defaults to 22):"

        # Write the config file.
        env['config'].create_config_file(client_key, api_key, ssh_key_path, ssh_user, ssh_port)

        @app.call(env)
      end
    end
  end
end

