module Tugboat
  module Middleware
    class AddKey < Base
      def call(env)
        ocean = env['barge']

        if env["add_key_pub_key"]
          pub_key_string = env["add_key_pub_key"]
        else
          if env["add_key_file_path"]
            pub_key_string = File.read(env["add_key_file_path"])
          else
            possible_keys = Dir.glob("#{ENV['HOME']}/.ssh/*.pub")

            # Only show hinted keys if the user has any
            if possible_keys.size > 0
              say "Possible public key paths from #{ENV['HOME']}/.ssh:"
              say
              possible_keys.each do |key_file|
                say "#{key_file}"
              end
              say
            end

            ssh_key_file = ask "Enter the path to your SSH key:"
            pub_key_string = File.read("#{ssh_key_file}")
          end
        end

        say "Queueing upload of SSH key '#{env["add_key_name"]}'...", nil, false

        response = ocean.key.create :name => env["add_key_name"],
                               :public_key  => pub_key_string

        if response.success?
          say "done", :green
        else
          say "Failed to create key: #{response.message}", :red
          exit 1
        end

        say "SSH Key uploaded with Name: #{response.ssh_key.name} ID: #{response.ssh_key.id}", :green

        @app.call(env)
      end
    end
  end
end

