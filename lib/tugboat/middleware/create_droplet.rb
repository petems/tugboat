module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queueing creation of droplet '#{env["create_droplet_name"]}'...", nil, false

        env["create_droplet_region_id"] ?
        droplet_region_id = env["create_droplet_region_id"] :
        droplet_region_id = env["config"].default_region

        env["create_droplet_image_id"] ?
        droplet_image_id = env["create_droplet_image_id"] :
        droplet_image_id = env["config"].default_image

        env["create_droplet_size_id"] ?
        droplet_size_id = env["create_droplet_size_id"] :
        droplet_size_id = env["config"].default_size

        env["create_droplet_ssh_key_ids"] ?
        droplet_ssh_key_id = env["create_droplet_ssh_key_ids"] :
        droplet_ssh_key_id = env["config"].default_ssh_key

        env["create_droplet_private_networking"] ?
        droplet_private_networking = env["create_droplet_private_networking"] :
        droplet_private_networking = env["config"].default_private_networking

        env["create_droplet_backups_enabled"] ?
        droplet_backups_enabled = env["create_droplet_backups_enabled"] :
        droplet_backups_enabled = env["config"].default_backups_enabled

        create_opts = {
          :name               => env["create_droplet_name"],
          :size               => droplet_size_id,
          :image              => "#{droplet_image_id}",
          :region             => droplet_region_id,
          :ssh_keys           => [droplet_ssh_key_id],
          :private_networking => droplet_private_networking,
          :backups_enabled    => droplet_backups_enabled,
          :ipv6               => nil,
        }

        response = ocean.droplet.create(create_opts)
        if response.success?
          say "done", :green
        else
          say "Failed to create Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end

