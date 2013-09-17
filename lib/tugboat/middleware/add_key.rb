module Tugboat
  module Middleware
    class AddKey < Base
      def call(env)
        ocean = env["ocean"]
      
        if env["add_key_pub_key"]
          pub_key_string = env["add_key_pub_key"]
        else          
          if env["add_key_file_path"]
            pub_key_string = File.read(env["add_key_file_path"])
          else
            say "No pub key string given, I'm going to suggest some from your ~/.ssh folder"
            Dir.glob('/Users/pmorley/.ssh/*.pub') do |key_file|
              say "#{key_file}"
            end
            ssh_key_file = ask "Choose a file path to use from the list above:"
            pub_key_string = File.read("#{ssh_key_file}")
          end        
        end

        puts pub_key_string

        say "Queueing upload of ssh key '#{env["add_key_name"]}'...", nil, false

        req = ocean.ssh_keys.add    :name => env["add_key_name"],
                                    :ssh_pub_key  => pub_key_string

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

