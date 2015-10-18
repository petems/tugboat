module Tugboat
  module Middleware
    class ListSizes < Base
      def call(env)
        ocean = env['barge']
        sizes = ocean.size.all.sizes

        say "Sizes:"
        sizes.each do |size|
          say "Disk: #{size.disk}GB, Memory: #{size.memory.round}MB (slug: #{size.slug})"
        end

        @app.call(env)
      end
    end
  end
end
