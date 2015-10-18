module Tugboat
  module Middleware
    class ListSSHKeys < Base
      def call(env)

        ocean = env['barge']
        ssh_keys = ocean.key.all.ssh_keys

        say "SSH Keys:"
        ssh_keys.ssh_keys.each do |key|
          say "#{key.name} (id: #{key.id})"
        end

        @app.call(env)
      end
    end
  end
end

