module Tugboat
  module Middleware
    class DestroyImage < Base
      def call(env)
        ocean = env['barge']

        say "Queuing destroy image for #{env['image_id']} #{env['image_name']}...", nil, false

        response = ocean.image.destroy env['image_id']

        if response.success?
          say 'Image deletion successful!', :green
        else
          say "Failed to destroy image: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
