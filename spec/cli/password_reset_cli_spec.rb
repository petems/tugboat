require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "passwordreset" do
    it "resets the root password given a fuzzy name" do
            stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      @cli.password_reset("example.co")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos
    end

    it "resets the root password given an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      stub_request(:get, "https://api.digitalocean.com/v2/droplets/6918990?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})

      @cli.options = @cli.options.merge(:id => 6918990)
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos
    end

    it "resets the root password given a name" do
            stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      @cli.options = @cli.options.merge(:name => "example.com")
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos
    end

    it "raises SystemExit when a request fails" do
      pending 'Not yet'
         stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
      to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)


      expect { @cli.password_reset("foo") }.to raise_error(SystemExit)
    end
  end
end
