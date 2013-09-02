module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queueing creation of droplet '#{env["create_droplet_name"]}'...", nil, false

        if env["config"].default_region
          droplet_region_id = env["config"].default_region
        else
          droplet_region_id = env["create_droplet_region_id"]
        end

        if env["config"].default_image
          droplet_image_id = env["config"].default_image
        else
          droplet_image_id = env["create_droplet_image_id"]
        end

        if env["config"].default_size
          droplet_size_id = env["config"].default_size
        else
          droplet_size_id = env["create_droplet_size_id"]
        end

        req = ocean.droplets.create :name   => env["create_droplet_name"],
                                 :size_id   => droplet_size_id,
                                 :image_id  => droplet_image_id,
                                 :region_id => droplet_region_id,
                                 :ssh_key_ids => env["create_droplet_ssh_key_ids"]

        if req.status == "ERROR"
          say req.error_message, :red
          exit 1
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

