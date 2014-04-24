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
        say
        say "To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`."
        say "Defaults can be changed at any time in your ~/.tugboat configuration file."
        say
        region   = ask "Enter your default region ID (optional, defaults to 1 (New York)):"
        image    = ask "Enter your default image ID (optional, defaults to 3240036 (Ubuntu 14.04 x64)):"
        size     = ask "Enter your default size ID (optional, defaults to 66 (512MB)):"
        ssh_key  = ask "Enter your default ssh key ID (optional, defaults to none):"
        private_networking = ask "Enter your default for private networking (optional, defaults to false):"
        backups_enabled = ask "Enter your default for enabling backups (optional, defaults to false):"

        # Write the config file.
        env['config'].create_config_file(client_key, api_key, ssh_key_path, ssh_user, ssh_port, region, image, size, ssh_key, private_networking, backups_enabled)
        env['config'].reload!

        @app.call(env)
      end
    end
  end
end

