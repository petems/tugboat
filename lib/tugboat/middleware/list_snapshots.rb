module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListSnapshots < Base
      def call(env)
        ocean = env['droplet_kit']

        verify_credentials(ocean)

        response = ocean.snapshots.all(per_page: env['per_page'])

        has_one = false

        response.each do |snapshot|
          has_one = true

          say "#{snapshot.name} (id: #{snapshot.id}, resource_type: #{snapshot.resource_type}, created_at: #{snapshot.created_at})"
        end

        unless has_one
          say "You don't appear to have any snapshots.", :red
        end

        @app.call(env)
      end
    end
  end
end
