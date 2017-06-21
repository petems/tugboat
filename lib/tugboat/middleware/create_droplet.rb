module Tugboat
  module Middleware
    class CreateDroplet < Base
      def call(env)
        ocean = env['barge']

        say "Queueing creation of droplet '#{env['create_droplet_name']}'...", nil, false

        droplet_region_slug = env['create_droplet_region_slug'] ? env['create_droplet_region_slug'] : env['config'].default_region

        droplet_image_slug = env['create_droplet_image_slug'] ? env['create_droplet_image_slug'] : env['config'].default_image

        droplet_size_slug = env['create_droplet_size_slug'] ? env['create_droplet_size_slug'] : env['config'].default_size

        droplet_ssh_key_ids = env['create_droplet_ssh_key_ids'] ? env['create_droplet_ssh_key_ids'] : env['config'].default_ssh_key

        droplet_private_networking = env['create_droplet_private_networking'] ? env['create_droplet_private_networking'] : env['config'].default_private_networking

        droplet_ip6 = env['create_droplet_ip6'] ? env['create_droplet_ip6'] : env['config'].default_ip6

        droplet_user_data = env['create_droplet_user_data'] ? env['create_droplet_user_data'] : env['config'].default_user_data

        if droplet_user_data
          if File.file?(droplet_user_data)
            user_data_string = File.open(droplet_user_data, 'rb', &:read)
          else
            say "Could not find file: #{droplet_user_data}, check your user_data setting"
            exit 1
          end
        end

        droplet_backups_enabled = env['create_droplet_backups_enabled'] ? env['create_droplet_backups_enabled'] : env['config'].default_backups_enabled

        droplet_key_array = if droplet_ssh_key_ids.is_a?(Array)
                              droplet_ssh_key_ids
                            else
                              droplet_ssh_key_ids.to_s.split(',')
                            end

        create_opts = {
          name: env['create_droplet_name'],
          size: droplet_size_slug,
          image: droplet_image_slug.to_s,
          region: droplet_region_slug,
          ssh_keys: droplet_key_array,
          private_networking: droplet_private_networking,
          backups_enabled: droplet_backups_enabled,
          ipv6: droplet_ip6,
          user_data: user_data_string
        }

        response = ocean.droplet.create(create_opts)

        unless response.success?
          say "Failed to create Droplet: #{response.message}", :red
          exit 1
        end

        say "Droplet created! Droplet ID is #{response.droplet[:id]}"

        @app.call(env)
      end
    end
  end
end
