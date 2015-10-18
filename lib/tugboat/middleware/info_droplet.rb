module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env['barge']

        response = ocean.droplet.show env["droplet_id"]

        unless response.success?
          say "Failed to get info for Droplet: #{response.message}", :red
          exit 1
        end

        droplet = response.droplet

        unless response.success?
          say "Failed to find droplet: #{response.message}", :red
          exit 1
        end

        if droplet.status == "active"
          status_color = GREEN
        else
          status_color = RED
        end

        attribute = env["user_attribute"]

        attributes_list = [
          ["name",  droplet.name],
          ["id",  droplet.id],
          ["status",  droplet.status],
          ["ip",  droplet.ip_address],
          ["private_ip",  droplet.private_ip_address],
          ["region_id",  droplet.region_id],
          ["image_id",  droplet.image_id],
          ["size_id",  droplet.size_id],
          ["backups_active",  (droplet.backups_active || false)]
        ]
        attributes = Hash[*attributes_list.flatten(1)]

        if attribute
          if attributes.has_key? attribute
            say attributes[attribute]
          else
            say "Invalid attribute \"#{attribute}\"", :red
            say "Provide one of the following:", :red
            attributes_list.keys.each { |a| say "    #{a[0]}", :red }
          end
        else
          if env["user_porcelain"]
            attributes_list.select{ |a| a[1] != nil }.each{ |a| say "#{a[0]} #{a[1]}"}
          else
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
          end
        end

        @app.call(env)
      end
    end
  end
end

