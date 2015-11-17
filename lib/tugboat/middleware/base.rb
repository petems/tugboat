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

      # Get all pages of droplets
      def get_droplet_list(ocean)
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

