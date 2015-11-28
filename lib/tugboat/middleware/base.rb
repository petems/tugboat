module Tugboat
  module Middleware
    # A base middleware class to initalize.
    class Base
      # Some colors for making things pretty.
      CLEAR      = "\e[0m"
      RED        = "\e[31m"
      GREEN      = "\e[32m"
      YELLOW     = "\e[33m"

      # We want access to all of the fun thor cli helper methods,
      # like say, yes?, ask, etc.
      include Thor::Shell

      def initialize(app)
        @app = app
        # This resets the color to "clear" on the user's terminal.
        say "", :clear, false
      end

      def call(env)
        @app.call(env)
      end

      def verify_credentials(ocean, say_success=false)
        begin
          response = ocean.droplet.all({:per_page =>'1', :page =>'1'})
        rescue Faraday::ClientError => e
          say "Authentication with DigitalOcean failed at an early stage"
          say "Error was: #{e}"
          exit 1
        end

        unless response.success?
          say "Failed to connect to DigitalOcean. Reason given from API: #{response.id} - #{response.message}", :red
          exit 1
        end

        say "Authentication with DigitalOcean was successful.", :green if say_success
      end

      # Get all pages of droplets
      def get_droplet_list(ocean)

        verify_credentials(ocean)

        page = ocean.droplet.all(per_page: 200, page: 1)
        if not page.paginated?
          return page.droplets
        end

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

