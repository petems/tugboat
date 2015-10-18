module Tugboat
  module Middleware
    class InfoImage < Base
      def call(env)
        ocean = env['barge']

        response = ocean.image.show env["image_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
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
