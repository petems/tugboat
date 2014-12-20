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
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))

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
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))

      @cli.droplets

      expect($stdout.string).to include('Response from https://api.digitalocean.com/droplets?client_id=[CLIENT-ID]&api_key=[API-KEY]; Status: 200;')

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end
end

