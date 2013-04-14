module Tugboat
  module Middleware
    class ListImages < Base
      def call(env)
        ocean = env["ocean"]
        my_images = ocean.images.list :filter => "my_images"
        if env["user_show_global_images"]
          global = ocean.images.list :filter => "global"
        end

        say "My Images:"
        my_images.images.each do |image|
          say "#{image.name} (id: #{image.id}, distro: #{image.distribution})"
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

