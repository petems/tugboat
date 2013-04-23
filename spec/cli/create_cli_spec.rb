require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "create a droplet" do
    it "with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id&name=#{droplet_name}&region_id&size_id&ssh_key_ids").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos
      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id&name=#{droplet_name}&region_id&size_id&ssh_key_ids")).to have_been_made
    end

    it "with args" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=2672&name=#{droplet_name}&region_id=2&size_id=64&ssh_key_ids=1234").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.options = @cli.options.merge(:image => 2672, :size => 64, :region => 2, :keys => "1234")
      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=2672&name=foo&region_id=2&size_id=64&ssh_key_ids=1234")).to have_been_made
    end
  end


end

