require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'resize' do
    it 'resizes a droplet with a fuzzy name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:post, 'https://api.digitalocean.com/v2/droplets/6918990/actions').
        with(body: '{"type":"resize","size":"1gb"}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('resize_droplet'), headers: {})

      cli.options = cli.options.merge(size: '1gb')
      cli.resize('example.com')

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing resize for 6918990 (example.com)...Resize complete!
      eos
    end

    it 'resizes a droplet with an id' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      stub_request(:post, 'https://api.digitalocean.com/v2/droplets/6918990/actions').
        with(body: '{"type":"resize","size":"1gb"}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('resize_droplet'), headers: {})

      cli.options = cli.options.merge(size: '1gb', id: 6_918_990)
      cli.resize

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)
Queuing resize for 6918990 (example.com)...Resize complete!
      eos
    end

    it 'resizes a droplet with a name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:post, 'https://api.digitalocean.com/v2/droplets/6918990/actions').
        with(body: '{"type":"resize","size":"1gb"}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('resize_droplet'), headers: {})

      cli.options = cli.options.merge(size: '1gb', name: 'example.com')
      cli.resize

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing resize for 6918990 (example.com)...Resize complete!
      eos
    end

    it 'raises SystemExit when a request fails' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:post, 'https://api.digitalocean.com/v2/droplets/6918990/actions').
        with(body: '{"type":"resize","size":"1gb"}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 500, body: '{"status":"ERROR","message":"Some error"}')

      cli.options = cli.options.merge(size: '1gb')
      expect { cli.resize('example.com') }.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing resize for 6918990 (example.com)...Failed to resize Droplet: Some error
      eos
    end
  end
end
