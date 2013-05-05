require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "ssh" do
    it "tries to fetch the droplet's IP from the API" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      Kernel.stub(:exec)

      @cli.ssh("test222")

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end

    it "does not allow ssh into a droplet that is inactive" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_inactive"))

      Kernel.stub(:exec)

      @cli.options = @cli.options.merge(:name => droplet_name)

      expect {@cli.ssh("test222")}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Droplet must be in an 'active' state for this operation to be successful.
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end
end
