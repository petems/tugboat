module Tugboat
  module Middleware
    class ListImages < Base
      def call(env)
        ocean = env['barge']
        my_images = ocean.image.all :filter => "my_images"
        if env["user_show_global_images"]
          global = ocean.image.all :filter => "global"
        end

        say "My Images:"
        my_images_list = my_images.images
        if my_images_list.empty?
          say "No images found"
        else
          my_images_list.each do |image|
            say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
          end
        end

        if env["user_show_global_images"]
          say
          say "Global Images:"
          global.images.each do |image|
            say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
          end
        end

        @app.call(env)
      end
    end
  end
end