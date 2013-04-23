require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "show" do
    it "shows a droplet with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.info("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)

Name:             foo
ID:               100823
Status:           \e[32mactive\e[0m
IP:               33.33.33.10
Region ID:        1
Image ID:         420
Size ID:          33
Backups Active:   false
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "shows a droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.info

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)

Name:             foo
ID:               100823
Status:           \e[32mactive\e[0m
IP:               33.33.33.10
Region ID:        1
Image ID:         420
Size ID:          33
Backups Active:   false
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "shows a droplet with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      stub_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.info

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)

Name:             foo
ID:               100823
Status:           \e[32mactive\e[0m
IP:               33.33.33.10
Region ID:        1
Image ID:         420
Size ID:          33
Backups Active:   false
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end
