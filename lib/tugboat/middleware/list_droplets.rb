module Tugboat
  module Middleware
    # Check if the client has set-up configuration yet.
    class ListDroplets < Base
      def call(env)
        client = env["client"]
        ui = env["ui"]

        ui.say("Requesting droplets", :output)

        droplets = client.droplet.all(per_page: 200).droplets

        if droplets.empty?
          ui.say("No droplets were found on your account", :warn)
          ui.say("You can create one with `tugboat create`", :info)
          ui.fail
        end

        ui.say("Listing droplets", :output)
        ui.say("Showing a maximum of 200 droplets", :info)
        ui.say("", :info)

        droplets.each do |droplet|
          ui.say("#{droplet.name.ljust(30)} #{droplet_status(droplet.status, ui)}", :data)
          ui.say("#{droplet.networks.v4[0].ip_address.ljust(30)} #{droplet.networks.v6[0].ip_address if droplet.networks.v6.any?}", :info)
          ui.say("#{droplet.image.name.ljust(30)} #{droplet.region.name}", :info)
          ui.say("#{droplet.size!.slug.ljust(30)} #{droplet.id}", :info)
          ui.say("", :info)
        end

        @app.call(env)
      end

      def droplet_status(status, ui)
        if status == "active"
          return ui.green(status)
        else
          return ui.yellow(status)
        end
      end
    end
  end
end

