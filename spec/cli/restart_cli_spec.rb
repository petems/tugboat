require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "restarts a droplet" do
    it "with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"reboot\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('restart_response'), :headers => {})

      @cli.restart("example.com")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing restart for 6918990 (example.com)...Restart complete!
      eos

    end

    it "restarts a droplet hard when the hard option is used" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"power_cycle\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => "", :headers => {})

      @cli.options = @cli.options.merge(:hard => true)
      @cli.restart("example.com")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing hard restart for 6918990 (example.com)...Restart complete!
      eos
    end

    it "with an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets/3164494?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplet'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/3164494/actions").
         with(:body => "{\"type\":\"reboot\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('restart_response'), :headers => {})

      @cli.options = @cli.options.merge(:id => '3164494')
      @cli.restart

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 3164494 (example.com)
Queuing restart for 3164494 (example.com)...Restart complete!
      eos
    end


    it "with a name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"reboot\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('restart_response'), :headers => {})

      @cli.options = @cli.options.merge(:name => 'example.com')
      @cli.restart

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing restart for 6918990 (example.com)...Restart complete!
      eos
    end

  end

end
