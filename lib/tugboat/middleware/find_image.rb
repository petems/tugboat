module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class FindImage < Base
      def call(env)
        ocean = env['barge']
        user_fuzzy_name = env['user_image_fuzzy_name']
        user_image_name = env['user_image_name']
        user_image_id = env['user_image_id']

        # First, if nothing is provided to us, we should quit and
        # let the user know.
        if !user_fuzzy_name && !user_image_name && !user_image_id
          say "Tugboat attempted to find an image with no arguments. Try `tugboat help`", :red
          exit 1
        end

        # If you were to `tugboat restart foo -n foo-server-001` then we'd use
        # 'foo-server-001' without looking up the fuzzy name.
        #
        # This is why we check in this order.

        # Easy for us if they provide an id. Just set it to the image_id
        if user_image_id
          say "Image id provided. Finding Image...", nil, false
          response = ocean.image.show user_image_id

          unless response.success?
            say "Failed to find Image: #{response.message}", :red
            exit 1
          end

          env["image_id"] = response.image.id
          env["image_name"] = "(#{response.image.name})"
        end

        # If they provide a name, we need to get the ID for it.
        # This requires a lookup.
        if user_image_name && !env["image_id"]
          say "Image name provided. Finding Image...", nil, false

          # Look for the image by an exact name match.
          ocean.image.all['images'].each do |d|
            if d.name == user_image_name
              env["image_id"] = d.id
              env["image_name"] = "(#{d.name})"
            end
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["image_id"]
            say "error\nUnable to find a image named '#{user_image_name}'.", :red
            exit 1
          end
        end

        # We only need to "fuzzy find" a image if a fuzzy name is provided,
        # and we don't want to fuzzy search if an id or name is provided
        # with a flag.
        #
        # This requires a lookup.
        if user_fuzzy_name && !env["image_id"]
          say "Image fuzzy name provided. Finding image ID...", nil, false

          found_images = []
          choices = []

          ocean.image.all['images'].each_with_index do |d, i|

            # Check to see if one of the image names have the fuzzy string.
            if d.name.upcase.include? user_fuzzy_name.upcase
              found_images << d
            end
          end

          # Check to see if we have more then one image, and prompt
          # a user to choose otherwise.
          if found_images.length == 1
            env["image_id"] = found_images.first.id
            env["image_name"] = "(#{found_images.first.name})"
          elsif found_images.length > 1
            # Did we run the multiple questionairre?
            did_run_multiple = true

            say "Multiple images found."
            say
            found_images.each_with_index do |d, i|
              say "#{i}) #{d.name} (#{d.id})"
              choices << i.to_s
            end
            say
            choice = ask "Please choose a image:", :limited_to => choices
            env["image_id"] = found_images[choice.to_i].id
            env["image_name"] = found_images[choice.to_i].name
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["image_id"]
            say "error\nUnable to find an image named '#{user_fuzzy_name}'.", :red
            exit 1
          end
        end

        if !did_run_multiple
          say "done#{CLEAR}, #{env["image_id"]} #{env["image_name"]}", :green
        end
        @app.call(env)
      end
    end
  end
end

