module Tugboat
  module Middleware
    class ListRegions < Base
      def call(env)
        ocean = env["ocean"]
        regions = ocean.regions.list.regions

        say "Regions:"
        regions.each do |region|
          say "#{region.name} (id: #{region.id}) (slug: #{region.slug})"
        end

        @app.call(env)
      end
    end
  end
end
