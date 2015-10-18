module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env['barge']

        droplet_list = ocean.droplet.all.droplets

        if droplet_list.empty?
          say "You don't appear to have any droplets.", :red
          say "Try creating one with #{GREEN}\`tugboat create\`#{CLEAR}"
        else
          droplet_list.each do |droplet|

            if droplet.private_ip_address
              private_addr = droplet.networks.v4.detect { |address| address.type == 'private' }
              private_ip = ", privateip: #{private_addr.ip_address}"
            end

            if droplet.status == "active"
              status_color = GREEN
            else
              status_color = RED
            end

            public_addr = droplet.networks.v4.detect { |address| address.type == 'public' }
            say "#{droplet.name} (ip: #{public_addr.ip_address}#{private_ip}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region.slug}, id: #{droplet.id})"
          end
        end

        @app.call(env)
      end
    end
  end
end

