module Tugboat
  module Middleware
    class InfoDroplet < Base
      def call(env)
        ocean = env['barge']

        response = ocean.droplet.show env['droplet_id']

        check_response_success('get info for Droplet', response)

        droplet = response.droplet

        unless response.success?
          say "Failed to find droplet: #{response.message}", :red
          exit 1
        end

        status_color = if droplet.status == 'active'
                         GREEN
                       else
                         RED
                       end

        attribute = env['user_attribute']

        droplet_ip4_public = droplet.networks.v4.find { |address| address.type == 'public' }.ip_address unless droplet.networks.v4.empty?
        droplet_ip6_public = droplet.networks.v6.find { |address| address.type == 'public' }.ip_address unless droplet.networks.v6.empty?
        check_private_ip   = droplet.networks.v4.find { |address| address.type == 'private' }
        droplet_private_ip = check_private_ip.ip_address if check_private_ip

        attributes_list = [
          ['name', droplet.name],
          ['id', droplet.id],
          ['status', droplet.status],
          ['ip4',  droplet_ip4_public],
          ['ip6',  droplet_ip6_public],
          ['private_ip', droplet_private_ip],
          ['region', droplet.region.slug],
          ['image', droplet.image.id],
          ['size', droplet.size_slug],
          ['backups_active', !droplet.backup_ids.empty?]
        ]
        attributes = Hash[*attributes_list.flatten(1)]

        if attribute
          if attributes.key? attribute
            say attributes[attribute]
          else
            say "Invalid attribute \"#{attribute}\"", :red
            say 'Provide one of the following:', :red
            attributes_list.each { |a| say "    #{a[0]}", :red }
            exit 1
          end
        else
          if env['user_porcelain']
            attributes_list.select { |a| !a[1].nil? }.each { |a| say "#{a[0]} #{a[1]}" }
          else
            say
            say "Name:             #{droplet.name}"
            say "ID:               #{droplet.id}"
            say "Status:           #{status_color}#{droplet.status}#{CLEAR}"
            say "IP4:              #{droplet_ip4_public}" unless droplet.networks.v4.empty?
            say "IP6:              #{droplet_ip6_public}" unless droplet.networks.v6.empty?

            say "Private IP:       #{droplet_private_ip}" if droplet_private_ip

            image_description = if droplet.image.slug.nil?
                                  droplet.image.name
                                else
                                  droplet.image.slug
                                end

            say "Region:           #{droplet.region.name} - #{droplet.region.slug}"
            say "Image:            #{droplet.image.id} - #{image_description}"
            say "Size:             #{droplet.size_slug.upcase}"
            say "Backups Active:   #{!droplet.backup_ids.empty?}"
          end
        end

        @app.call(env)
      end
    end
  end
end
