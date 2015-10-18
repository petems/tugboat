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
              private_ip = ", privateip: #{droplet.private_ip_address}"
            end

            if droplet.status == "active"
              status_color = GREEN
            else
              status_color = RED
            end

            say "#{droplet.name} (ip: #{droplet.ip_address}#{private_ip}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region_id}, id: #{droplet.id})"
          end
        end

        @app.call(env)
      end
    end
  end
end

