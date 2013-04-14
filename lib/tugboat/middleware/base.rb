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

    end
  end
end

