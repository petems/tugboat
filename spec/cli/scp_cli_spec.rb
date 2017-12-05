require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'scp' do
    it "tries to fetch the droplet's IP from the API" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with("scp -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar")

expected_string = <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Executing SCP on Droplet (example.com)...
Attempting SCP with `scp -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar`
      eos

      expect { cli.scp('example.com', '/tmp/foo', '/tmp/bar') }.to output(expected_string).to_stdout
    end

    it "runs with rsync if given at the command line" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with("rsync -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar")

expected_string = <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Executing SCP on Droplet (example.com)...
Attempting SCP with `rsync -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar`
      eos

      cli.options = cli.options.merge(scp_command: 'rsync')

      expect { cli.scp('example.com', '/tmp/foo', '/tmp/bar') }.to output(expected_string).to_stdout
    end

    it "wait's until droplet active if -w command is given and droplet eventually active" do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: '', headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(
          { status: 200, body: fixture('show_droplet_inactive'), headers: {} },
          status: 200, body: fixture('show_droplet'), headers: {}
        )

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_droplets'))
      allow(Kernel).to receive(:exec).with("scp -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar")

      cli.options = cli.options.merge(wait: true)

      expected_string = <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Executing SCP on Droplet (example.com)...
Wait flag given, waiting for droplet to become active
..done\e[0m (2s)
Attempting SCP with `scp -i #{Dir.home}/.ssh/id_rsa2 /tmp/foo baz@104.236.32.182:/tmp/bar`
      eos

      expect { cli.scp('example.com', '/tmp/foo', '/tmp/bar') }.to output(expected_string).to_stdout
    end

  end
end
