require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "droplets" do
    it "shows a list when droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      #stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
      #to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
example.com (ip: 104.236.32.182, status: \e[32mactive\e[0m, region: nyc3, id: 6918990)
example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, id: 3164444)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end

    it "returns an error message when no droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets_empty"), :headers => {'Content-Type' => 'application/json'},)

      @cli.droplets

      expect($stdout.string).to eq <<-eos
You don't appear to have any droplets.
Try creating one with \e[32m`tugboat create`\e[0m
      eos

      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end
    it "shows no output when --quiet is set" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      @cli.options = @cli.options.merge(:quiet => true)
      @cli.droplets

      # Should be /dev/null not stringIO
      expect($stdout).to be_a File

      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end
  end

end

