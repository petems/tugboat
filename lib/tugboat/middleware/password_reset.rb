module Tugboat
  module Middleware
    class PasswordReset < Base
      def call(env)
        ocean = env['barge']

        say "Queuing password reset for #{env['droplet_id']} #{env['droplet_name']}...", nil, false
        response = ocean.droplet.password_reset env['droplet_id']

        if response.success?
          say 'Password reset successful!', :green
          say 'Your new root password will be emailed to you', :green
        else
          say "Failed to reset password on Droplet: #{response.message}", :red
          exit 1
        end

        @app.call(env)
      end
    end
  end
end
