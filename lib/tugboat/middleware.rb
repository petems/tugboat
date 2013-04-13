require "middleware"

module Tugboat
  module Middleware
    autoload :Base, "tugboat/middleware/base"
    autoload :CheckConfiguration, "tugboat/middleware/check_configuration"
    autoload :AskForCredentials, "tugboat/middleware/ask_for_credentials"
    autoload :CheckCredentials, "tugboat/middleware/check_credentials"

    # This takes the user through the authorization flow.
    def self.sequence_authorize
      ::Middleware::Builder.new do
        use CheckConfiguration
        use AskForCredentials
        use CheckCredentials
      end
    end
  end
end
