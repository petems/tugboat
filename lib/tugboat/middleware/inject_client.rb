require 'digital_ocean'
require File.expand_path('../authentication_middleware', __FILE__)

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base

      def tugboat_faraday
        Faraday.new(:url => 'https://api.digitalocean.com/') do |faraday|
          faraday.use AuthenticationMiddleware, @client_id, @api_key
          faraday.use Faraday::Response::RaiseError
          faraday.request  :url_encoded
          faraday.response :rashify
          faraday.response :json
          faraday.response(:logger) if ENV['DEBUG']
          faraday.adapter Faraday.default_adapter
        end
      end

        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          @client_id = env["config"].client_key
          @api_key   = env["config"].api_key

          env["ocean"]  = DigitalOcean::API.new \
                             :client_id => @client_id,
                             :api_key   => @api_key,
                             :faraday => tugboat_faraday

          @app.call(env)
        end
    end
  end
end

