module Tugboat
  module Middleware
    class SCPDroplet < Base
      def call(env)
        say "Executing SCP on Droplet #{env['droplet_name']}..."

        identity = File.expand_path(env['config'].ssh_key_path.to_s).strip

        ssh_user = env['user_droplet_ssh_user'] || env['config'].ssh_user

        scp_command = env['user_scp_command'] || 'scp'

        host_ip = env['droplet_ip']

        host_string = "#{ssh_user}@#{host_ip}"

        if env['user_droplet_ssh_wait']
          say 'Wait flag given, waiting for droplet to become active'
          wait_for_state(env['droplet_id'], 'active', env['barge'])
        end

        identity_string = "-i #{identity}"

        scp_command_string = [scp_command, identity_string, env['user_from_file'], "#{host_string}:#{env['user_to_file']}"].join(' ')

        say "Attempting SCP with `#{scp_command_string}`"

        Kernel.exec(scp_command_string)

        @app.call(env)
      end
    end
  end
end
