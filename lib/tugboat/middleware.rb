require "middleware"

module Tugboat
  module Middleware
    autoload :Base, "tugboat/middleware/base"
    autoload :CheckAndInjectConfiguration, "tugboat/middleware/check_and_inject_configuration"
    autoload :AskForCredentials, "tugboat/middleware/ask_for_credentials"
    autoload :InjectClient, "tugboat/middleware/inject_client"
    autoload :CheckCredentials, "tugboat/middleware/check_credentials"

    # This takes the user through the authorization flow
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use CheckAndInjectConfiguration
        use AskForCredentials
        use InjectClient
        use CheckCredentials
      end
    end

    # This provides a list of droplets
    def self.sequence_list
      ::Middleware::Builder.new do
        use CheckAndInjectConfiguration
        use CheckCredentials
      end
    end
  end
end
