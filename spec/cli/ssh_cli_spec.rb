require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'ssh' do
    it "tries to fetch the droplet's IP from the API" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with('ssh', anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything)

      @cli.ssh('example.com')
    end

    it "wait's until droplet active if -w command is given and droplet already active" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: '', headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with('ssh', anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything)

      @cli.options = @cli.options.merge(wait: true)

      @cli.ssh('example.com')

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Executing SSH on Droplet (example.com)...
Wait flag given, waiting for droplet to become active
.done\e[0m (0s)
Attempting SSH: baz@104.236.32.182
SShing with options: -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -i #{Dir.home}/.ssh/id_rsa2 -p 33 baz@104.236.32.182
      eos
    end

    it "wait's until droplet active if -w command is given and droplet eventually active" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: '', headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(
          { status: 200, body: fixture('show_droplet_inactive'), headers: {} },
          status: 200, body: fixture('show_droplet'), headers: {}
        )

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with('ssh', anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything, anything)

      @cli.options = @cli.options.merge(wait: true)

      @cli.ssh('example.com')

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Executing SSH on Droplet (example.com)...
Wait flag given, waiting for droplet to become active
..done\e[0m (2s)
Attempting SSH: baz@104.236.32.182
SShing with options: -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -i #{Dir.home}/.ssh/id_rsa2 -p 33 baz@104.236.32.182
      eos
    end

    it 'does not allow ssh into a droplet that is inactive' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.11.0' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec)

      expect { @cli.ssh('example3.com') }.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 3164444 (example3.com)
Droplet must be on for this operation to be successful.
      eos
    end
  end
end
