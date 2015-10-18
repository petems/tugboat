require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "DEBUG=1" do
    before(:each) do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(1)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
    end

    it "gives full faraday logs" do
      pending 'Debug flag not avaliable yet'
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      @cli.droplets

      expect($stdout.string).to include('Response from https://api.digitalocean.com/droplets?client_id=foo&api_key=bar; Status: 200;')

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

  describe "DEBUG=2" do
    before(:each) do
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DEBUG').and_return(2)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
    end

    it "gives full faraday logs with redacted API keys" do
      pending 'Debug flag not avaliable yet'
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      @cli.droplets

      expect($stdout.string).to include('Response from https://api.digitalocean.com/droplets?client_id=[CLIENT-ID]&api_key=[API-KEY]; Status: 200;')

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end
end

