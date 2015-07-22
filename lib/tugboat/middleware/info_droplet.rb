module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env['barge']

        response = ocean.droplet.show env["droplet_id"]

        require 'pry'; binding.pry;

        unless response.success?
          say "Failed to get infor for Droplet: #{response.message}", :red
          exit 1
        end

        droplet = response.droplet

        if response.success?
          say "done", :green
        else
          say "Failed to find droplet: #{response.message}", :red
          exit 1
        end

        attribute = env["user_attribute"]

        attributes_list = [
          ["name",  droplet.name],
          ["id",  droplet.id],
          ["status",  droplet.status],
          ["ip4",  droplet.networks.v4[0].ip_address],
          ["ip4",  droplet.networks.v6[0].ip_address],
          ["private_ip",  droplet.private_ip_address],
          ["region",  droplet.region],
          ["Image",  droplet.image.id],
          ["size",  droplet.size_slug],
          ["backups_active",  !droplet.backup_ids.empty?]
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
            say "IP4:              #{droplet.networks.v4[0].ip_address}"
            say "IP6:              #{droplet.networks.v6[0].ip_address}"

            if droplet.private_ip_address
              say "Private IP:       #{droplet.private_ip_address}"
            end

            say "Region:           #{droplet.region.name} - #{droplet.region.slug}"
            say "Image:            #{droplet.image.id} - #{droplet.image.name}"
            say "Size:             #{droplet.size_slug.upcase}"
            say "Backups Active:   #{!droplet.backup_ids.empty?}"
          end
        end

        @app.call(env)
      end
    end
  end
end

