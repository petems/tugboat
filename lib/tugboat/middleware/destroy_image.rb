module Tugboat
  module Middleware
    class DestroyImage < Base
      def call(env)
        ocean = env['barge']

        say "Queuing destroy image for #{env["image_id"]} #{env["image_name"]}...", nil, false

        req = ocean.images.delete env["image_id"]

        if req.status == "ERROR"
          say "#{req.status}: #{req.error_message}", :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

