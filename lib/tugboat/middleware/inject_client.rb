require 'barge'

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base
        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          @access_token = env["config"].access_token

          def tugboat_faraday
            Faraday.new(:url => 'https://api.digitalocean.com/') do |faraday|
              faraday.use AuthenticationMiddleware, @client_id, @api_key
              faraday.use Faraday::Response::RaiseError
              faraday.use CustomLogger if ENV['DEBUG']
              faraday.request  :url_encoded
              faraday.response :rashify
              faraday.response :json, :content_type => /\b(json|json-home)$/
              faraday.adapter Faraday.default_adapter
            end
          end

          env['barge'] = Barge::Client.new(:access_token => @access_token)

          @app.call(env)
        end
    end
  end
end

