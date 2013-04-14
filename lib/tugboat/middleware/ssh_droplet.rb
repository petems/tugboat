module Tugboat
  module Middleware
    class SSHDroplet < Base
      def call(env)
        say "Executing SSH #{env["droplet_name"]}..."

        options = [
          "-o", "IdentitiesOnly=yes",
          "-o", "LogLevel=ERROR",
          "-o", "StrictHostKeyChecking=no",
          "-o", "UserKnownHostsFile=/dev/null",
          "-i", env["config"].ssh_key_path.to_s]

        host_string = "#{env["config"].ssh_user}@#{env["droplet_ip"]}"

        options << host_string


        Kernel.exec("ssh", *options)

        @app.call(env)
      end
    end
  end
end

