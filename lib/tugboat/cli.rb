require 'thor'

module Tugboat
  class CLI < Thor

    desc "authorize", "Authorize an DigitalOcean account with Tugboat"
    def authorize
      say "Note: You can get this stuff at digitalocean.com/api_access", :yellow
      say
      client_key = ask "Enter your client key:"
      secret_key = ask "Enter your API key:"
      say secret_key, client_key
      say
      say "Checking..."
      say "Succesfully authenticated.", :green
    end

    desc "list", "Retrieve a list of your droplets"
    def list
      say "pearkes-admin-001 (region: 1, size: 64, image ID: 2676)"
      say "pearkes-www-001 (region: 1, size: 64, image ID: 2561)"
      say "pearkes-api-001 (region: 1, size: 64, image ID: 6321)"
    end

    desc "ssh", "SSH into a droplet"
    def ssh
      say "Found droplet: 'pearkes-admin-001'", :green
      say "Executing SSH..."
    end

    desc "create", "Create a droplet"
    def create
      droplet_name = ask "Enter name of droplet:"
      say "Creating '#{droplet_name}' (region: 1, size: 64, image ID: 2676)...", :yellow
      say "Succesfully created '#{droplet_name}'", :green
    end

    desc "destroy", "Destroy a droplet"
    def destroy
      droplet_name = ask "Enter name of droplet to destroy:"
      say
      confirm = ask "Warning! Potentially destructive action. Please re-enter droplet name, '#{droplet_name}':", :red
      say "Confirmation: #{confirm}"
      say
      say "Destroying '#{droplet_name}'...", :yellow
      say "Succesfully destroyed '#{droplet_name}'", :green
    end

    desc "restart", "Restart a droplet"
    def restart
      say "Restarting: 'pearkes-admin-001'", :yellow
      say
      say "Succesfully restarted 'pearkes-admin-001'.", :green
    end

    desc "halt", "Shutdown a droplet"
    def halt
      say "Shutting down: 'pearkes-admin-001'", :yellow
      say
      say "Succesfully shut down 'pearkes-admin-001'.", :green
    end

    desc "halt", "Shutdown a droplet"
    def snapshot
      ask "Please enter name of snapshot:"
      say "Queuing 'test' snapshot for 'pearkes-admin-001'..."
      say
      say "Succesfully queued snapshot.", :green
    end
  end
end

