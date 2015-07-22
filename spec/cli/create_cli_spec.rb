require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "create a droplet" do
    it "with a name, uses defaults from configuration" do
      stub_request(:post, "https://api.digitalocean.com/v2/droplets").
         with(:body => "{\"name\":\"foo\",\"size\":\"666\",\"image\":\"555\",\"region\":\"3\",\"ssh_keys\":[\"4321\"],\"private_networking\":\"false\",\"backups_enabled\":\"false\",\"ipv6\":null}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => "", :headers => {})

      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos
    end

    it "with args does not use defaults from configuration" do
      # stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=555&name=foo&backups_enabled=#{backups_enabled}&private_networking=#{private_networking}&region_id=3&size_id=666&ssh_key_ids=4321").
      #    to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => '{"status":"OK"}')

      @cli.options = @cli.options.merge(:image => '555', :size => '666', :region => '3', :keys => '4321')
      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos

      # expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=555&name=foo&backups_enabled=#{backups_enabled}&private_networking=#{private_networking}&region_id=3&size_id=666&ssh_key_ids=4321")).to have_been_made
    end

    it "doesn't create a droplet when mistyping help command" do
      help_text = <<-eos
Usage:
  rspec create NAME

Options:
  -s, [--size=N]              # The size_id of the droplet
  -i, [--image=N]             # The image_id of the droplet
  -r, [--region=N]            # The region_id of the droplet
  -k, [--keys=KEYS]           # A comma separated list of SSH key ids to add to the droplet
  -p, [--private-networking]  # Enable private networking on the droplet
  -b, [--backups-enabled]     # Enable backups on the droplet
  -q, [--quiet]

Create a droplet.
eos

      @cli.create('help')
      expect($stdout.string).to eq help_text

      @cli.create('--help')
      expect($stdout.string).to eq help_text + help_text

      @cli.create('-h')
      expect($stdout.string).to eq help_text + help_text + help_text
    end

    it "does not clobber named droplets that contain the word help" do
      # stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=#{image}&name=somethingblahblah--help&backups_enabled=#{backups_enabled}&private_networking=#{private_networking}&region_id=#{region}&size_id=#{size}&ssh_key_ids=#{ssh_key_id}").
      #    to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => '{"status":"OK"}')

      @cli.create('somethingblahblah--help')

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet 'somethingblahblah--help'...done
      eos
    end
  end
end
