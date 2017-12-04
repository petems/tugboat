module Tugboat
  module Middleware
    class BackupConfig < Base
      def call(env)
        ocean = env['droplet_kit']

        if env['disable'] && env['enable']
          say 'You cannot use both --disable and --enable for backup_config', :red
          exit 1
        end

        begin
          if env['disable']
            response = ocean.droplet_actions.disable_backups(droplet_id: env['droplet_id'])
          end
          if env['enable']
            response = ocean.droplet_actions.enable_backups(droplet_id: env['droplet_id'])
          end
        rescue DropletKit::Error => e
          say "Failed to configure backups on droplet. Reason given from API: #{e}", :red
          exit 1
        end

        say "Backup action #{response_stringify(response)} is #{response.status}"

        @app.call(env)
      end
    end
  end
end
