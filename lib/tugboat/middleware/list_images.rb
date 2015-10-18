module Tugboat
  module Middleware
    class ListImages < Base
      def call(env)
        ocean = env['barge']
        my_images = ocean.image.all(:private => true)
        public_images = ocean.image.all.images - my_images.images

        if env['user_show_just_private_images']
          say "Showing just private images", :green
          say "Private Images:", :blue
          my_images_list = my_images.images
          if my_images_list.nil? || my_images_list.empty?
            say "No private images found"
          else
            my_images_list.each do |image|
              say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
            end
          end
        else
          say "Showing both private and public images"
          say "Private Images:", :blue
          my_images_list = my_images.images
          if my_images_list.nil? || my_images_list.empty?
            say "No private images found"
          else
            my_images_list.each do |image|
              say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
            end
          end
          say ''
          say "Public Images:", :blue
          public_images.each do |image|
            say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
          end
        end

        @app.call(env)
      end
    end
  end
end