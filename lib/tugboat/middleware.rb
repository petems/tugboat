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


    # This takes the user through the authorization flow
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use InjectConfiguration
        use AskForCredentials
        use CheckConfiguration
        use InjectClient
        use CheckCredentials
      end
    end

    # This provides a list of droplets
    def self.sequence_list_droplets
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use ListDroplets
      end
    end

    # This restarts a droplet
    def self.sequence_restart_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use RestartDroplet
      end
    end

    # This halts a droplet
    def self.sequence_halt_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use HaltDroplet
      end
    end

    # This shows a droplet
    def self.sequence_info_droplet
      ::Middleware::Builder.new do
        use InjectConfiguration
        use CheckConfiguration
        use InjectClient
        use FindDroplet
        use InfoDroplet
      end
    end
  end
end
