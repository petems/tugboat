module Tugboat
  module Middleware
    class UploadSSHKey < Base
      def call(env)
        ocean = env["ocean"]

        say "Queueing upload of ssh key '#{env["upload_ssh_key_name"]}'...", nil, false

        req = ocean.ssh_keys.add    :name => env["upload_ssh_key_name"],
                                    :ssh_pub_key  => env["upload_ssh_key_pub_key"]

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

