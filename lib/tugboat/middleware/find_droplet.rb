module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class FindDroplet < Base
      def call(env)
        user_fuzzy_name = env['user_droplet_fuzzy_name']
        user_droplet_name = env['user_droplet_name']
        user_droplet_id = env['user_droplet_id']
        # First, if nothing is provided to us, we should quit and
        # let the user know.
        if !user_fuzzy_name && !user_droplet_name && !user_droplet_id
          say "ERROR: tugboat info was called with invalid arguments"
          say "Usage: 'tugboat info FUZZY_NAME [OPTIONS]'"
          say
          say "Try tugboat help for more"
          return
        end

        # If you were to `tugboat restart foo -n foo-server-001` then we'd use
        # 'foo-server-001' without looking up the fuzzy name.
        #
        # This is why we check in this order.

        # Easy for us if they provide an id. Just set it to the droplet_id
        if user_droplet_id
          env["droplet_id"] = user_droplet_id
          say "Droplet ID provided...", nil, false
        end

        # If they provide a name, we need to get the ID for it.
        # This requires a lookup.
        if user_droplet_name && !env["droplet_id"]
          say "Droplet name provided. Finding droplet ID...", nil, false

          # Look for the droplet by an exact name match.
          env["ocean"].droplets.list.droplets.each do |droplet|
            if droplet.name == user_droplet_name
              env["droplet_id"] = droplet.id
            end
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["droplet_id"]
            say "Unable to find a droplet named '#{user_droplet_name}'.", :red
            return
          end
        end

        # We only need to "fuzzy find" a droplet if a fuzzy name is provided,
        # and we don't want to fuzzy search if an id or name is provided
        # with a flag.
        #
        # This requires a lookup.
        if user_fuzzy_name && !env["droplet_id"]
          say "Droplet fuzzy name provided. Finding droplet ID...", nil, false

          env["ocean"].droplets.list.droplets.each do |droplet|
            # Check to see if one of the droplet names have the fuzzy string.
          end

          # If we coulnd't find it, tell the user and drop out of the
          # sequence.
          if !env["droplet_id"]
            say "Unable to find a droplet named '#{user_fuzzy_name}'.", :red
            return
          end
        end

        say "done, #{env["droplet_id"]}", :green
        @app.call(env)
      end
    end
  end
end

