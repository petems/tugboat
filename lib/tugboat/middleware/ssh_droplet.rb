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

        if env["user_droplet_ssh_port"]
          options.push("-p", env["user_droplet_ssh_port"].to_s)
        elsif env["config"].ssh_port
          options.push("-p", env["config"].ssh_port.to_s)
        else
          options.push("-p", "22")
        end

        host_string = "#{env["config"].ssh_user}@#{env["droplet_ip"]}"

        options << host_string

        Kernel.exec("ssh", *options)

        @app.call(env)
      end
    end
  end
end

