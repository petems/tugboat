module Tugboat
  class CustomLogger < Faraday::Middleware
      extend Forwardable
      def_delegators :@logger, :debug, :info, :warn, :error, :fatal

      def initialize(app, options = {})
        @app = app
        @logger = options.fetch(:logger) {
          require 'logger'
          ::Logger.new(STDOUT)
        }
      end

      def call(env)
        start_time = Time.now
        info  { request_info(env) }
        debug { request_debug(env) }
        @app.call(env).on_complete do
          end_time = Time.now
          response_time = end_time - start_time
          info  { response_info(env, response_time) }
          debug { response_debug(env) }
        end
      end

      private

      def filter(output)
        unless ENV['DEBUG'] == '2'
          output = output.to_s.gsub(/client_id=[a-zA-Z0-9]*/,'client_id=[REDACTED]')
          output = output.to_s.gsub(/api_key=[a-zA-Z0-9]*/,'api_key=[REDACTED]')
          output = output.to_s.gsub(/_digitalocean2_session_v2=[a-zA-Z0-9%-]*/,'_digitalocean2_session_v2=[SESSION_COOKIE]')
        else
          output
        end
      end

      def request_info(env)
        "Started %s request to: %s" % [ env[:method].to_s.upcase, filter(env[:url]) ]
      end

      def response_info(env, response_time)
        "Response from %s; Status: %d; Time: %.1fms" % [ filter(env[:url]), env[:status], (response_time * 1_000.0) ]
      end

      def request_debug(env)
        debug_message("Request", env[:request_headers], env[:body])
      end

      def response_debug(env)
        debug_message("Response", env[:response_headers], env[:body])
      end

      def debug_message(name, headers, body)
        <<-MESSAGE.gsub(/^ +([^ ])/m, '\\1')
        #{name} Headers:
        ----------------
        #{format_headers(headers)}

        #{name} Body:
        -------------
        #{body}
        MESSAGE
      end

      def format_headers(headers)
        length = headers.map {|k,v| k.to_s.size }.max
        headers.map { |name, value| "#{name.to_s.ljust(length)} : #{filter(value)}" }.join("\n")
      end

  end
end
