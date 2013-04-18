module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env["ocean"]

        say "Queueing creation of droplet '#{env["create_droplet_name"]}'...", nil, false

        req = ocean.droplets.create :name   => env["create_droplet_name"],
                                 :size_id   => env["create_droplet_size_id"],
                                 :image_id  => env["create_droplet_image_id"],
                                 :region_id => env["create_droplet_region_id"],
                                 :ssh_key_ids => env["create_droplet_ssh_key_ids"]

        if req.status == "ERROR"
          say req.error_message, :red
          return
        end

        say "done", :green

        @app.call(env)
      end
    end
  end
end

