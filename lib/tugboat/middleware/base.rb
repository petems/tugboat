module Tugboat
  module Middleware
    # A base middleware class to initalize.
    class Base
      # We want access to all of the fun thor cli helper methods,
      # like say, yes?, ask, etc.
      include Thor::Shell

      def initialize(app)
        @app = app
      end
    end
  end
end

