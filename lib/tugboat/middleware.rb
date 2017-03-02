require "middleware"

module Tugboat
  module Middleware
    autoload :AddKey, "tugboat/middleware/add_key"
    autoload :AskForCredentials, "tugboat/middleware/ask_for_credentials"
    autoload :Base, "tugboat/middleware/base"
    autoload :CheckConfiguration, "tugboat/middleware/check_configuration"
    autoload :CheckCredentials, "tugboat/middleware/check_credentials"
    autoload :CheckDropletActive, "tugboat/middleware/check_droplet_active"
    autoload :CheckDropletInactive, "tugboat/middleware/check_droplet_inactive"
    autoload :Config, "tugboat/middleware/config"
    autoload :ConfirmAction, "tugboat/middleware/confirm_action"
    autoload :CreateDroplet, "tugboat/middleware/create_droplet"
    autoload :RebuildDroplet, "tugboat/middleware/rebuild_droplet"
    autoload :DestroyDroplet, "tugboat/middleware/destroy_droplet"
    autoload :DestroyImage, "tugboat/middleware/destroy_image"
    autoload :FindDroplet, "tugboat/middleware/find_droplet"
    autoload :FindImage, "tugboat/middleware/find_image"
    autoload :HaltDroplet, "tugboat/middleware/halt_droplet"
    autoload :InfoDroplet, "tugboat/middleware/info_droplet"
    autoload :InfoImage, "tugboat/middleware/info_image"
    autoload :InjectClient, "tugboat/middleware/inject_client"
    autoload :InjectConfiguration, "tugboat/middleware/inject_configuration"
    autoload :InjectUI, "tugboat/middleware/inject_ui"
    autoload :ListDroplets, "tugboat/middleware/list_droplets"
    autoload :ListImages, "tugboat/middleware/list_images"
    autoload :ListRegions, "tugboat/middleware/list_regions"
    autoload :ListSizes, "tugboat/middleware/list_sizes"
    autoload :ListSSHKeys, "tugboat/middleware/list_ssh_keys"
    autoload :PasswordReset, "tugboat/middleware/password_reset"
    autoload :ResizeDroplet, "tugboat/middleware/resize_droplet"
    autoload :RestartDroplet, "tugboat/middleware/restart_droplet"
    autoload :SnapshotDroplet, "tugboat/middleware/snapshot_droplet"
    autoload :SSHDroplet, "tugboat/middleware/ssh_droplet"
    autoload :StartDroplet, "tugboat/middleware/start_droplet"
    autoload :WaitForState, "tugboat/middleware/wait_for_state"

    # Start the authorization flow.
    # This writes a ~/.tugboat file, which can be edited manually.
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use AskForCredentials
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    # This checks that the credentials in ~/.tugboat are valid
    def self.sequence_verify
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    # Display a list of droplets
    def self.sequence_list_droplets
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListDroplets
      end
    end

    # Display a list of images
    def self.sequence_list_images
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListImages
      end
    end

    # Restart a droplet
    def self.sequence_restart_droplet
      ::Middleware::Builder.new do
        use InjectUI
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
        use InjectUI
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
        use InjectUI
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
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use InfoDroplet
      end
    end

    # Show information about an image
    def self.sequence_info_image
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindImage
        use InfoImage
      end
    end

    # SSH into a droplet
    def self.sequence_ssh_droplet
      ::Middleware::Builder.new do
        use InjectUI
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
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use CreateDroplet
      end
    end

    # Rebuild a droplet
    def self.sequence_rebuild_droplet
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use FindImage
        use ConfirmAction
        use RebuildDroplet
      end
    end

    # Destroy a droplet
    def self.sequence_destroy_droplet
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use ConfirmAction
        use DestroyDroplet
      end
    end

    # Destroy an image
    def self.sequence_destroy_image
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindImage
        use ConfirmAction
        use DestroyImage
      end
    end

    # Snapshot a droplet
    def self.sequence_snapshot_droplet
      ::Middleware::Builder.new do
        use InjectUI
        use InjectUI
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
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListSSHKeys
      end
    end

    # Create a droplet
    def self.sequence_add_key
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use AddKey
      end
    end

    # Display a list of regions
    def self.sequence_regions
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListRegions
      end
    end

    # Display a list of droplet sizes
    def self.sequence_sizes
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListSizes
      end
    end

    # Resize a droplet
    def self.sequence_resize_droplet
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use ResizeDroplet
      end
    end

    # Reset root password
    def self.sequence_password_reset
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use PasswordReset
      end
    end

    # Returns current used config
    def self.sequence_config
      ::Middleware::Builder.new do
        use Config
      end
    end

    # Wait for a droplet to enter a desired state
    def self.sequence_wait
      ::Middleware::Builder.new do
        use InjectUI
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use WaitForState
      end
    end
  end
end
