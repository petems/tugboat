module Tugboat
  module Middleware
    # Check if the droplet in the environment is inactive, or "off"
    class Config < Base
      def call(env)

        config = Tugboat::Configuration.instance

        keys_retracted = ''

        config_data = config.data.to_yaml.gsub(/"/,'')

        if env["user_hide_keys"]
          keys_retracted = '(Keys Redacted)'
          config_data = config_data.gsub(/(client_key: )([a-zA-Z0-9]+)/,'\1 [REDACTED]')
          config_data = config_data.gsub(/(api_key: )([a-zA-Z0-9]+)/,'\1 [REDACTED]')
        end

        say "Current Config #{keys_retracted}\n", :green

        say "Path: #{config.path}"
        say config_data

        @app.call(env)
      end
    end
  end
end

