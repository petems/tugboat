module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env["ocean"]

        ocean.droplets.list.droplets.each do |droplet|

          if droplet.status == "active"
            status_color = GREEN
          else
            status_color = RED
          end

          say "#{droplet.name} (ip: #{droplet.ip_address}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region_id}, id: #{droplet.id})"
        end

        @app.call(env)
      end
    end
  end
end

