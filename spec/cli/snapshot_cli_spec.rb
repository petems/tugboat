require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  let(:snapshot_name)     { "foo-snapshot" }

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "snapshots a droplet" do
    it "with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_inactive"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.snapshot(snapshot_name, "foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Warning: Droplet must be in a powered off state for snapshot to be successful
Queuing snapshot 'foo-snapshot' for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}")).to have_been_made
    end

    it "with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet_inactive"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.snapshot(snapshot_name)

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Warning: Droplet must be in a powered off state for snapshot to be successful
Queuing snapshot 'foo-snapshot' for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}")).to have_been_made
    end


    it "with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_inactive"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.snapshot(snapshot_name)

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Warning: Droplet must be in a powered off state for snapshot to be successful
Queuing snapshot 'foo-snapshot' for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/snapshot?api_key=#{api_key}&client_id=#{client_key}&name=#{snapshot_name}")).to have_been_made
    end

    it "does not snaphshot a droplet that is active" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      expect {@cli.snapshot(snapshot_name)}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Droplet must be off for this operation to be successful.
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end
