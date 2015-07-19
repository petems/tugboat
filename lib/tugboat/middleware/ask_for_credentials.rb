module Tugboat
  module Middleware
    # Ask for user credentials from the command line, then write them out.
    class AskForCredentials < Base
      def call(env)
        say "Note: You can get your Access Token from https://cloud.digitalocean.com/settings/tokens/new", :yellow
        say
        access_token = ask "Enter your access token:"
        ssh_key_path = ask "Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa):"
        ssh_user = ask "Enter your SSH user (optional, defaults to root):"
        ssh_port = ask "Enter your SSH port number (optional, defaults to 22):"
        say
        say "To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`."
        say "Defaults can be changed at any time in your ~/.tugboat configuration file."
        say
        region   = ask "Enter your default region (optional, defaults to nyc1):"
        image    = ask "Enter your default image ID or image slug (optional, defaults to ubuntu-14-04-x64):"
        size     = ask "Enter your default size (optional, defaults to 512mb)):"
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

