require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "DEBUG=1" do
    before(:each) do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(1)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
    end

    it "gives full faraday logs" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.11.0'}).
        to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.11.0'}).
        to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      @cli.droplets

      expect($stdout.string).to include "Started GET request to: https://api.digitalocean.com/v2/droplets?page=1&per_page=200"
      expect($stdout.string).to include "DEBUG -- : Request Headers:"

      expect($stdout.string).to include "Bearer foo"
    end
  end

  describe "DEBUG=2" do
    before(:each) do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(2)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
    end

    it "gives full faraday logs with redacted API keys" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=1").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.11.0'}).
        to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?page=1&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.11.0'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      @cli.droplets

      expect($stdout.string).to include "Started GET request to: https://api.digitalocean.com/v2/droplets?page=1&per_page=200"
      expect($stdout.string).to include "DEBUG -- : Request Headers:"

      expect($stdout.string).to_not include "Bearer foo"
    end
  end

end

