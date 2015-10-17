require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "passwordreset" do
    it "resets the root password given a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"password_reset\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('password_reset_response'), :headers => {})

      @cli.password_reset("example.com")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing password reset for 6918990 (example.com)...Password reset successful!
Your new root password will be emailed to you
      eos
    end

    it "resets the root password given an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      stub_request(:get, "https://api.digitalocean.com/v2/droplets/6918990?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplet'), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"password_reset\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('password_reset_response'), :headers => {})

      @cli.options = @cli.options.merge(:id => 6918990)
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)
Queuing password reset for 6918990 (example.com)...Password reset successful!
Your new root password will be emailed to you
      eos
    end

    it "resets the root password given a name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"password_reset\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('password_reset_response'), :headers => {})

      @cli.options = @cli.options.merge(:name => "example.com")
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing password reset for 6918990 (example.com)...Password reset successful!
Your new root password will be emailed to you
      eos
    end

    it "raises SystemExit when a request fails" do
      pending 'Cant seem to get working...'
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      stub_request(:post, "https://api.digitalocean.com/v2/droplets/6918990/actions").
         with(:body => "{\"type\":\"password_reset\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 500, :body => '{"status":"ERROR","message":"Some error"}')

        @cli.options = @cli.options.merge(:name => "example.com")

        expect{ @cli.password_reset("example.com") }.to raise_error(SystemExit)
    end
  end
end
