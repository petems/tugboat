require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "start" do
    it "starts the droplet with a fuzzy name" do

      @cli.start("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing start for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "starts the droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets/3164494?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet_inactive"))

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/3164494/actions").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet_inactive"))


      @cli.options = @cli.options.merge(:id => '3164494')
      @cli.start

      expect($stdout.string).to eq "Droplet id provided. Finding Droplet...done\e[0m, 3164494 (example.com)\nQueuing start for 3164494 (example.com)..."
    end


    it "starts the droplet with a name" do

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.start

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing start for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_on?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "does not start a droplet that is inactive" do

      @cli.options = @cli.options.merge(:name => droplet_name)
      expect {@cli.start}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Droplet must be off for this operation to be successful.
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end
end
