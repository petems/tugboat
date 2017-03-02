module Tugboat
  class CustomLogger < Faraday::Middleware
    extend Forwardable
    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize(app, options = {})
      @app = app
      @logger = options.fetch(:logger) do
        require 'logger'
        ::Logger.new($stdout)
      end
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
      if ENV['DEBUG'].to_i == 2
        output = output.to_s.gsub(%r{Bearer [a-zA-Z0-9]*}, 'Bearer [TOKEN REDACTED]')
        output = output.to_s.gsub(%r{_digitalocean2_session_v2=[a-zA-Z0-9%-]*}, '_digitalocean2_session_v2=[SESSION_COOKIE]')
      else
        output
      end
    end

    def request_info(env)
      format('Started %s request to: %s', env[:method].to_s.upcase, filter(env[:url]))
    end

    def response_info(env, response_time)
      format('Response from %s; Status: %d; Time: %.1fms', filter(env[:url]), env[:status], (response_time * 1_000.0))
    end

    def request_debug(env)
      debug_message('Request', env[:request_headers], env[:body])
    end

    def response_debug(env)
      debug_message('Response', env[:response_headers], env[:body])
    end

    def debug_message(name, headers, body)
      main_message = <<-MESSAGE.gsub(%r{^ +([^ ])}m, '\\1')
        #{name} Headers:
        ----------------
        #{format_headers(headers)}

        #{name} Body:
        -------------
        MESSAGE
      main_message + pretty_body(body)
    end

    def pretty_body(body)
      body_json = JSON.parse(body)
      JSON.pretty_generate(body_json)
    rescue JSON::ParserError
      body
    end

    def format_headers(headers)
      length = headers.map { |k, _v| k.to_s.size }.max
      headers.map { |name, value| "#{name.to_s.ljust(length)} : #{filter(value)}" }.join("\n")
    end
  end
end
