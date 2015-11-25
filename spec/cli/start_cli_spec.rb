require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "start" do
    it "starts the droplet with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/3164444/actions").
         with(:body => "{\"type\":\"power_on\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('droplet_start_response'), :headers => {})

      @cli.start("example3.com")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 3164444 (example3.com)
Queuing start for 3164444 (example3.com)...Start complete!
      eos
    end

    it "starts the droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets/3164494?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet_inactive"))

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/3164494/actions").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet_inactive"))


      @cli.options = @cli.options.merge(:id => '3164494')
      @cli.start

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 3164494 (example.com)
Queuing start for 3164494 (example.com)...Start complete!
      eos
    end


    it "starts the droplet with a name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/3164444/actions").
         with(:body => "{\"type\":\"power_on\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('droplet_start_response'), :headers => {})

      @cli.options = @cli.options.merge(:name => 'example3.com')
      @cli.start

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 3164444 (example3.com)
Queuing start for 3164444 (example3.com)...Start complete!
      eos
    end

    it "does not start a droplet that is inactive" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      @cli.options = @cli.options.merge(:name => 'example.com')
      expect {@cli.start}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Droplet must be off for this operation to be successful.
      eos


    end
  end
end
