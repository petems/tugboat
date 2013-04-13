        droplets.each do |droplet|
          say "#{droplet.name} (ip: #{droplet.ip_address}, status: #{droplet.status}, region: #{region_id})"
        end
