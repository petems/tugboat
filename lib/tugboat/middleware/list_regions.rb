module Tugboat
  module Middleware
    class ListRegions < Base
      def call(env)
        ocean = env['barge']
        regions = ocean.regions.list.regions.sort_by(&:name)

        say "Regions:"
        regions.each do |region|
          say "#{region.name} (id: #{region.id}) (slug: #{region.slug})"
        end

        @app.call(env)
      end
    end
  end
end
