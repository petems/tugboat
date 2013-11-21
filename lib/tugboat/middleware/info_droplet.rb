module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env["ocean"]

        req = ocean.droplets.show env["droplet_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        droplet = req.droplet

          if droplet.status == "active"
            status_color = GREEN
          else
            status_color = RED
          end

        region_name = Configuration::REGION_NAMES[droplet.region_id]
        size_name = Configuration::SIZE_NAMES[droplet.size_id]

        say
        say "Status:           #{status_color}#{droplet.status}#{CLEAR}"
        say "Name:             #{droplet.name}"
        say "ID:               #{droplet.id}"
        say "IP:               #{droplet.ip_address}"
        say "Region ID:        #{droplet.region_id} (#{region_name})"
        say "Image ID:         #{droplet.image_id}"
        say "Size ID:          #{droplet.size_id} (#{size_name})"
        say "Backups Active:   #{droplet.backups_active || false}"

        @app.call(env)
      end
    end
  end
end
