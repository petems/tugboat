require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'destroy' do
    it 'destroys a droplet with a fuzzy name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/6918990').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      expected_string = <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
eos

      expect { cli.destroy('example.com') }.to output(expected_string).to_stdout
    end

    it 'destroys a droplet with an id' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/6918990').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      cli.options = cli.options.merge(id: '6918990')

      expected_string = <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos

      expect { cli.destroy }.to output(expected_string).to_stdout
    end

    it 'destroys a droplet with a name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/6918990').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      cli.options = cli.options.merge(name: 'example.com')

      expected_string = <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos

      expect { cli.destroy }.to output(expected_string).to_stdout
    end

    it 'destroys a droplet with confirm flag set' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/6918990').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      cli.options = cli.options.merge(name: 'example.com', confirm: true)

      expected_string = <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos

      expect { cli.destroy }.to output(expected_string).to_stdout
    end

    it 'does not destroy a droplet if no is chosen' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      expect($stdin).to receive(:gets).and_return('n')

      expected_string = <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Aborted due to user request.
      eos

      expect { cli.destroy('example.com') }.to raise_error(SystemExit).and output(expected_string).to_stdout
    end

    it 'raises SystemExit when a request fails' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/6918990').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 500, body: '{"status":"ERROR","message":"Some error"}')

      expect($stdin).to receive(:gets).and_return('y')

      cli.options = cli.options.merge(name: 'example.com')

      expect { cli.destroy }.to raise_error(SystemExit).and output(%r{Failed to destroy Droplet: Some error}).to_stdout
    end
  end
end
