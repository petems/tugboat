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
    autoload :StartDroplet, "tugboat/middleware/start_droplet"
    autoload :HaltDroplet, "tugboat/middleware/halt_droplet"
    autoload :InfoDroplet, "tugboat/middleware/info_droplet"
    autoload :SSHDroplet, "tugboat/middleware/ssh_droplet"
    autoload :CreateDroplet, "tugboat/middleware/create_droplet"
    autoload :DestroyDroplet, "tugboat/middleware/destroy_droplet"
    autoload :ConfirmAction, "tugboat/middleware/confirm_action"
    autoload :SnapshotDroplet, "tugboat/middleware/snapshot_droplet"
    autoload :ResizeDroplet, "tugboat/middleware/resize_droplet"
    autoload :ListImages, "tugboat/middleware/list_images"
    autoload :ListSSHKeys, "tugboat/middleware/list_ssh_keys"
    autoload :ListRegions, "tugboat/middleware/list_regions"
    autoload :ListSizes, "tugboat/middleware/list_sizes"
    autoload :CheckDropletActive, "tugboat/middleware/check_droplet_active"
    autoload :CheckDropletInactive, "tugboat/middleware/check_droplet_inactive"

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

    # Start a droplet
    def self.sequence_start_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use CheckDropletInactive
        use StartDroplet
      end
    end

    # Shutdown a droplet
    def self.sequence_halt_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use CheckDropletActive
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
        use CheckDropletActive
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
        use CheckDropletInactive
        use SnapshotDroplet
      end
    end

    # Display a list of available SSH keys
    def self.sequence_ssh_keys
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListSSHKeys
      end
    end

    # Display a list of regions
    def self.sequence_regions
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListRegions
      end
    end

    # Display a list of droplet sizes
    def self.sequence_sizes
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListSizes
      end
    end

    # Resize a droplet
    def self.sequence_resize_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use ResizeDroplet
      end
    end
  end
end
