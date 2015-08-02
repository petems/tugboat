require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "ssh" do
    it "tries to fetch the droplet's IP from the API" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      allow(Kernel).to receive(:exec).with('ssh', anything(), anything(),anything(), anything(),anything(), anything(),anything(), anything(),anything(), anything(),anything(), anything(),anything())

      @cli.ssh("example.com")
    end

    it "does not allow ssh into a droplet that is inactive" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      allow(Kernel).to receive(:exec)

      expect {@cli.ssh("example3.com")}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 3164444 (example3.com)
Droplet must be on for this operation to be successful.
      eos
    end

  end
end
