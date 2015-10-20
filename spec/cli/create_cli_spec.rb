require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "create a droplet" do
    it "with a name, uses defaults from configuration" do
      stub_request(:post, "https://api.digitalocean.com/v2/droplets").
         with(:body => "{\"name\":\"foo\",\"size\":\"512mb\",\"image\":\"ubuntu-14-04-x64\",\"region\":\"nyc2\",\"ssh_keys\":[\"1234\"],\"private_networking\":\"false\",\"backups_enabled\":\"false\",\"ipv6\":null}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('create_droplet'), :headers => {})

      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...Droplet created!
      eos
    end

    it "with args does not use defaults from configuration" do
      stub_request(:post, "https://api.digitalocean.com/v2/droplets").
         with(:body => "{\"name\":\"example.com\",\"size\":\"1gb\",\"image\":\"ubuntu-12-04-x64\",\"region\":\"nyc3\",\"ssh_keys\":[\"foo_bar_key\"],\"private_networking\":\"false\",\"backups_enabled\":\"false\",\"ipv6\":null}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('create_droplet'), :headers => {})

      @cli.options = @cli.options.merge(:image => 'ubuntu-12-04-x64', :size => '1gb', :region => 'nyc3', :keys => 'foo_bar_key')
      @cli.create('example.com')

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet 'example.com'...Droplet created!
      eos

    end

    it "doesn't create a droplet when mistyping help command" do
      help_text = "Usage:\n  rspec create NAME\n\nOptions:\n  -s, [--size=N]              # The size_id of the droplet\n  -i, [--image=N]             # The image_id of the droplet\n  -r, [--region=N]            # The region_id of the droplet\n  -k, [--keys=KEYS]           # A comma separated list of SSH key ids to add to the droplet\n  -p, [--private-networking]  # Enable private networking on the droplet\n  -b, [--backups-enabled]     # Enable backups on the droplet\n  -q, [--quiet]               \n\nCreate a droplet.\n"

      @cli.create('help')
      expect($stdout.string).to eq help_text

      @cli.create('--help')
      expect($stdout.string).to eq help_text + help_text

      @cli.create('-h')
      expect($stdout.string).to eq help_text + help_text + help_text
    end

    it "does not clobber named droplets that contain the word help" do
      stub_request(:post, "https://api.digitalocean.com/v2/droplets").
         with(:body => "{\"name\":\"somethingblahblah--help\",\"size\":\"512mb\",\"image\":\"ubuntu-14-04-x64\",\"region\":\"nyc2\",\"ssh_keys\":[\"1234\"],\"private_networking\":\"false\",\"backups_enabled\":\"false\",\"ipv6\":null}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('create_droplet'), :headers => {})

      @cli.create('somethingblahblah--help')

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet 'somethingblahblah--help'...Droplet created!
      eos
    end
  end
end
