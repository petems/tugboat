require 'digital_ocean'
require_relative '../authentication_middleware'

module Tugboat
  module Middleware
    # Inject the digital ocean client into the environment
    class InjectClient < Base

      def custom_faraday
        Faraday.new(:url => @base_url, :ssl => @ssl) do |faraday|
          faraday.use AuthenticationMiddleware, @client_id, @api_key
          faraday.use Faraday::Response::RaiseError if @raise_status_errors
          faraday.request  :url_encoded
          faraday.response :rashify
          faraday.response :json
          faraday.response(:logger) if @debug
          faraday.adapter Faraday.default_adapter
        end
      end

        def call(env)
          # Sets the digital ocean client into the environment for use
          # later.
          @client_id = env["config"].client_key
          @api_key   = env["config"].api_key
          @base_url  = 'https://api.digitalocean.com/'
          @raise_status_errors = true

          env["ocean"]  = DigitalOcean::API.new \
                             :client_id => env["config"].client_key,
                             :api_key   => env["config"].api_key,
                             :debug => ENV['DEBUG'] || false,
                             :faraday => custom_faraday

          @app.call(env)
        end
    end
  end
end

