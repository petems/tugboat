require 'thor/error'

module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env["ocean"]

        ocean.droplets.list.droplets.each do |droplet|
          status_color = GREEN if droplet.status == "active" || RED
          say "#{droplet.name} (ip: #{droplet.ip_address}, status: #{status_color}#{droplet.status}#{CLEAR}, region: #{droplet.region_id})"
        end

        @app.call(env)
      end
    end
  end
end

