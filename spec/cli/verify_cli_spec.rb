require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "verify" do
    it "returns confirmation text when verify passes" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200)
      @cli.verify
      expect($stdout.string).to eq "Authentication with DigitalOcean was successful.\n"
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "returns error string when verify fails" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 401, :body => '{"status":"ERROR", "message":"Access Denied"}')
      expect { @cli.resize("verify") }.to raise_error(SystemExit)
      expect($stdout.string).to eq "Droplet fuzzy name provided. Finding droplet ID...\e[31m Authentication with DigitalOcean failed (the server responded with status 401)\n\e[0m Check your API keys and run `tugboat authorize` to re-enter them if needed\n"
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end

