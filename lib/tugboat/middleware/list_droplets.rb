module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env['droplet_kit']

        verify_credentials(ocean)

        droplet_list = get_droplet_list(ocean, env['per_page'])

        has_one = false

        droplet_list.each do |droplet|
          has_one = true

          private_addr = droplet.networks.v4.find { |address| address.type == 'private' }
          if private_addr
            private_ip = ", private_ip: #{private_addr.ip_address}"
          end

          status_color = if droplet.status == 'active'
                           GREEN
                         else
                           RED
                         end

          public_addr = droplet.networks.v4.find { |address| address.type == 'public' }

          say "#{droplet.name} (ip: #{public_addr.ip_address}#{private_ip}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region.slug}, size: #{droplet.size_slug}, id: #{droplet.id}#{env['include_urls'] ? droplet_id_to_url(droplet.id) : ''})"
        end

        unless has_one
          say "You don't appear to have any droplets.", :red
          say "Try creating one with #{GREEN}\`tugboat create\`#{CLEAR}"
        end

        @app.call(env)
      end

      private

      def droplet_id_to_url(id)
        ", url: 'https://cloud.digitalocean.com/droplets/#{id}'"
      end
    end
  end
end
