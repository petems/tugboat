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

        say
        say "Name:             #{droplet.name}"
        say "ID:               #{droplet.id}"
        say "Status:           #{status_color}#{droplet.status}#{CLEAR}"
        say "IP:               #{droplet.ip_address}"

        if droplet.private_ip_address
	        say "Private IP:       #{droplet.private_ip_address}"
	      end

        say "Region ID:        #{droplet.region_id}"
        say "Image ID:         #{droplet.image_id}"
        say "Size ID:          #{droplet.size_id}"
        say "Backups Active:   #{droplet.backups_active || false}"

        @app.call(env)
      end
    end
  end
end

