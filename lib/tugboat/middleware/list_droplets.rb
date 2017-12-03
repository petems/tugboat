module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        ocean = env['droplet_kit']

        verify_credentials(ocean)

        droplet_list = get_droplet_list(ocean, env['per_page'])

        has_one = false

        droplet_list.each do |droplet|
          has_one = true

          print_droplet_info(droplet, env['attribute'], env['porcelain'], env['include_urls'], env['include_name'])
        end

        unless has_one
          say "You don't appear to have any droplets.", :red
          say "Try creating one with #{GREEN}\`tugboat create\`#{CLEAR}"
        end

        @app.call(env)
      end

      private

      def droplet_id_to_url(id)
        ", url: 'https://cloud.digitalocean.com/droplets/#{id}'"
      end
    end
  end
end
