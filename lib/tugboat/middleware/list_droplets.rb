module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base

      def droplet_status(droplet)
        if droplet.status == "active"
          ['ON ', GREEN]
        else
          ['OFF', RED]
        end
      end

      def print_droplet_beautifuly(droplet)
        status, status_color = droplet_status droplet
        droplet_name = droplet.name[0,29].ljust(30, ' ')
        region_name = Configuration::REGION_NAMES[droplet.region_id].ljust(15, ' ')
        say "#{status_color}#{status}#{CLEAR} #{droplet_name} #{droplet.ip_address.ljust(15, ' ')} @ #{region_name}   ##{droplet.id}"
      end

      def call(env)
        ocean = env["ocean"]

        droplet_list = ocean.droplets.list.droplets

        if droplet_list.empty?
          say "You don't appear to have any droplets.", :red
          say "Try creating one with #{GREEN}\`tugboat create\`#{CLEAR}"
        else
          sort = :name # env["config"].default_sort_by
          droplet_list.sort_by {|d| d.send(sort) }.each do |droplet|
            print_droplet_beautifuly droplet
          end
        end

        @app.call(env)
      end
    end
  end
end
