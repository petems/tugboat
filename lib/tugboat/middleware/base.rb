module Tugboat
  module Middleware
    # A base middleware class to initalize.
    class Base
      # Some colors for making things pretty.
      CLEAR      = "\e[0m".freeze
      RED        = "\e[31m".freeze
      GREEN      = "\e[32m".freeze
      YELLOW     = "\e[33m".freeze

      # We want access to all of the fun thor cli helper methods,
      # like say, yes?, ask, etc.
      include Thor::Shell

      def initialize(app)
        @app = app
        # This resets the color to "clear" on the user's terminal.
        say '', :clear, false
      end

      def check_response_success(task_string, response)
        unless response.success?
          say "Failed to #{task_string}: #{response.message}", :red
          exit 1
        end
      end

      def call(env)
        @app.call(env)
      end

      def verify_credentials(ocean, say_success = false)
        begin
          if ocean.is_a?(DropletKit::Client)
            response = ocean.droplets.all(per_page: '1', page: '1')

            begin
              response.first
            rescue DropletKit::Error => e
              say "Failed to connect to DigitalOcean. Reason given from API:\n#{e}", :red
              exit 1
            end
          else
            response = ocean.droplet.all(per_page: '1', page: '1')

            unless response.success?
              say "Failed to connect to DigitalOcean. Reason given from API: #{response.id} - #{response.message}", :red
              exit 1
            end
          end
        rescue Faraday::ClientError => e
          say 'Authentication with DigitalOcean failed at an early stage'
          say "Error was: #{e}"
          exit 1
        end

        say 'Authentication with DigitalOcean was successful.', :green if say_success
      end

      def wait_for_state(droplet_id, desired_state, ocean)
        start_time = Time.now

        response = ocean.droplet.show droplet_id

        say '.', nil, false

        unless response.success?
          say "Failed to get status of Droplet: #{response.message}", :red
          exit 1
        end

        while response.droplet.status != desired_state
          sleep 2
          response = ocean.droplet.show droplet_id
          say '.', nil, false
        end

        total_time = (Time.now - start_time).to_i

        say "done#{CLEAR} (#{total_time}s)", :green
      end

      def restart_droplet(hard_restart, ocean, droplet_id = '', droplet_name = '')
        if hard_restart
          say "Queuing hard restart for #{droplet_id} #{droplet_name}...", nil, false
          ocean.droplet.power_cycle droplet_id
        else
          say "Queuing restart for #{droplet_id} #{droplet_name}...", nil, false
          ocean.droplet.reboot droplet_id
        end
      end

      # Get all pages of droplets
      def get_droplet_list(ocean, per_page = 20)
        verify_credentials(ocean)

        # Allow both Barge and DropletKit usage
        if ocean.is_a?(DropletKit::Client)
          # DropletKit self-paginates
          ocean.droplets.all(per_page: per_page)
        else
          page = ocean.droplet.all(per_page: 200, page: 1)
          return page.droplets unless page.paginated?

          Enumerator.new do |enum|
            page.droplets.each { |drop| enum.yield drop }
            for page_num in 2..page.last_page
              page = ocean.droplet.all(per_page: 200, page: page_num)
              page.droplets.each { |drop| enum.yield drop }
            end
          end
        end

      end
    end
  end
end
