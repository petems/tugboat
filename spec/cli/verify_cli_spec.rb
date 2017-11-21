require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'verify' do
    it 'returns confirmation text when verify passes' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      expect { cli.verify }.to output("Authentication with DigitalOcean was successful.\n").to_stdout
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made
    end

    it 'returns error when verify fails' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'text/html' }, status: 401, body: fixture('401'))

      expect { cli.verify }.to raise_error(SystemExit).and output(%r{Failed to connect to DigitalOcean. Reason given from API: unauthorized - Unable to authenticate you.}).to_stdout
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made
    end

    it 'returns error string when verify fails and a non-json reponse is given' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'text/html' }, status: 500, body: fixture('500', 'html'))

      expect { cli.verify }.to raise_error(SystemExit).and output(%r{<title>DigitalOcean - Seems we've encountered a problem!}).to_stdout

      # TODO: Make it so this doesnt barf up a huge HTML file...
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made
    end
  end
end
