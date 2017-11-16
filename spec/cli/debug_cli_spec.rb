require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'DEBUG=1' do
    before do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(1)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)
    end

    it 'gives full faraday logs' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      debug_droplets_expectation = expect { cli.droplets }

      debug_droplets_expectation.to output(%r{DEBUG -- : Request Headers:}).to_stdout
      debug_droplets_expectation.to output(%r{Bearer foo}).to_stdout
      debug_droplets_expectation.to output(%r{Started GET request to}).to_stdout
    end
  end

  describe 'DEBUG=2' do
    before do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(2)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)
    end

    it 'gives full faraday logs with redacted API keys' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      debug_droplets_expectation    = expect { cli.droplets }
      debug_droplets_expectation.to output(%r{Started GET request to}).to_stdout
      debug_droplets_expectation.to output(%r{DEBUG -- : Request Headers:}).to_stdout
      debug_droplets_expectation.to output(%r{Bearer \[TOKEN REDACTED\]}).to_stdout
      debug_droplets_expectation.not_to output(%r{Bearer foo}).to_stdout
    end
  end
end
