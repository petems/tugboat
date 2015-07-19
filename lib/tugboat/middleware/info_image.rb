module Tugboat
  module Middleware
    class InfoImage < Base
      def call(env)
        ocean = env['barge']

        response = ocean.images.show env["image_id"]

        if response.success?
          say "done", :green
        else
          say "Failed to get info for Image: #{response.message}", :red
          exit 1
        end

        image = response.image

        say
        say "Name:             #{image.name}"
        say "ID:               #{image.id}"
        say "Distribution:     #{image.distribution}"

        @app.call(env)
      end
    end
  end
end
