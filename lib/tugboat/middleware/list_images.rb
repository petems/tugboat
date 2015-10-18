module Tugboat
  module Middleware
    class ListImages < Base
      def call(env)
        ocean = env['barge']
        my_images = ocean.image.all(private: true)

        if env['user_show_private_images']
          say "My Images:"
          my_images_list = my_images.images
          if my_images_list.nil? || my_images_list.empty?
            say "No images found"
          else
            my_images_list.each do |image|
              say "#{image.name} (slug: #{image.slug}, id: #{image.id}, distro: #{image.distribution})"
            end
          end
        end

        say "Public Images:"
        global.images.each do |image|
          say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
        end

        @app.call(env)
      end
    end
  end
end