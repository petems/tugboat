require "middleware"

module Tugboat
  module Middleware
    autoload :Base, "tugboat/middleware/base"
    autoload :InjectConfiguration, "tugboat/middleware/inject_configuration"
    autoload :CheckConfiguration, "tugboat/middleware/check_configuration"
    autoload :AskForCredentials, "tugboat/middleware/ask_for_credentials"
    autoload :InjectClient, "tugboat/middleware/inject_client"
    autoload :CheckCredentials, "tugboat/middleware/check_credentials"
    autoload :ListDroplets, "tugboat/middleware/list_droplets"
    autoload :FindDroplet, "tugboat/middleware/find_droplet"
    autoload :RestartDroplet, "tugboat/middleware/restart_droplet"
    autoload :HaltDroplet, "tugboat/middleware/halt_droplet"
    autoload :InfoDroplet, "tugboat/middleware/info_droplet"
    autoload :SSHDroplet, "tugboat/middleware/ssh_droplet"
    autoload :CreateDroplet, "tugboat/middleware/create_droplet"
    autoload :DestroyDroplet, "tugboat/middleware/destroy_droplet"
    autoload :ConfirmAction, "tugboat/middleware/confirm_action"
    autoload :SnapshotDroplet, "tugboat/middleware/snapshot_droplet"
    autoload :ListImages, "tugboat/middleware/list_images"

    # Start the authorization flow.
    # This writes a ~/.tugboat file, which can be edited manually.
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use InjectConfiguration
        use AskForCredentials
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    # Display a list of droplets
    def self.sequence_list_droplets
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListDroplets
      end
    end

    # Display a list of images
    def self.sequence_list_images
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListImages
      end
    end

    # Restart a droplet
    def self.sequence_restart_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use RestartDroplet
      end
    end

    # Shutdown a droplet
    def self.sequence_halt_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use HaltDroplet
      end
    end

    # Show information about a droplet
    def self.sequence_info_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use InfoDroplet
      end
    end

    # SSH into a droplet
    def self.sequence_ssh_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use SSHDroplet
      end
    end

    # Create a droplet
    def self.sequence_create_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CreateDroplet
      end
    end

    # Destroy a droplet
    def self.sequence_destroy_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use ConfirmAction
        use DestroyDroplet
      end
    end

    # Snapshot a droplet
    def self.sequence_snapshot_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use SnapshotDroplet
      end
    end
  end
end
