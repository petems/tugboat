module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env['barge']

        verify_credentials(ocean)

        droplet_list = get_droplet_list ocean

        has_one = false
        droplet_list.each do |droplet|
          has_one = true

          private_addr = droplet.networks.v4.detect { |address| address.type == 'private' }
          if private_addr
            private_ip = ", privateip: #{private_addr.ip_address}"
          end

          if droplet.status == "active"
            status_color = GREEN
          else
            status_color = RED
          end

          public_addr = droplet.networks.v4.detect { |address| address.type == 'public' }
          say "#{droplet.name} (ip: #{public_addr.ip_address}#{private_ip}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region.slug}, id: #{droplet.id}#{env["include_urls"] ? droplet_id_to_url(droplet.id) : '' })"
        end

        if not has_one
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

