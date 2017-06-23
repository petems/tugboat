module Tugboat
  module Middleware
    class ListSizes < Base
      def call(env)
        ocean = env['droplet_kit']
        sizes = ocean.sizes.all

        say 'Sizes:'
        sizes.each do |size|
          say "Disk: #{size.disk}GB, Memory: #{size.memory.round}MB (slug: #{size.slug})"
        end

        @app.call(env)
      end
    end
  end
end
