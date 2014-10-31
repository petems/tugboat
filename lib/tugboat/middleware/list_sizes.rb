module Tugboat
  module Middleware
    class ListSizes < Base
      def call(env)
        ocean = env['barge']
        sizes = ocean.sizes.list.sizes

        say "Sizes:"
        sizes.each do |size|
          say "#{size.name} (id: #{size.id})"
        end

        @app.call(env)
      end
    end
  end
end
