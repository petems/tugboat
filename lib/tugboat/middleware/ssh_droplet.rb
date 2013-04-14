module Tugboat
  module Middleware
    class SSHDroplet < Base
      def call(env)
        say "Executing SSH #{env["droplet_name"]}...", nil, false

        exec("ssh root@#{env[:droplet_ip]}")

        @app.call(env)
      end
    end
  end
end

