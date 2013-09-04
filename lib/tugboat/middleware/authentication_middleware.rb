module Tugboat
  class AuthenticationMiddleware < Faraday::Middleware
    extend Forwardable
    def_delegators :'Faraday::Utils', :parse_query, :build_query
    RED        = "\e[31m"
    CLEAR      = "\e[0m"

    def initialize(app, client_id, api_key)
      @client_id = client_id
      @api_key   = api_key

      super(app)
    end

    def call(env)
      params = { 'client_id' => @client_id, 'api_key' => @api_key }.update query_params(env[:url])

      env[:url].query = build_query params

      begin
        @app.call(env)
      rescue Faraday::Error::ClientError => e
        puts "#{RED}#{e}!#{CLEAR}\n"
        if env[:body].status == "ERROR"
          puts "\n#{RED}#{env[:body].error_message}#{CLEAR}\n\n"
        end
        puts "Double-check your parameters and configuration (in your ~/.tugboat file)"
        exit 1
      end
    end

    def query_params(url)
      if url.query.nil? or url.query.empty?
        {}
      else
        parse_query url.query
      end
    end
  end
end
