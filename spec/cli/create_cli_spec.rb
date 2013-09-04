require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "create a droplet" do
    it "with a name, uses defaults from configuration" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=#{image}&name=#{droplet_name}&region_id=#{region}&size_id=#{size}&ssh_key_ids=#{ssh_key_id}").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos
      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=#{image}&name=#{droplet_name}&region_id=#{region}&size_id=#{size}&ssh_key_ids=#{ssh_key_id}")).to have_been_made
    end

    it "with args does not use defaults from configuration" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=555&name=foo&region_id=3&size_id=666&ssh_key_ids=4321").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.options = @cli.options.merge(:image => '555', :size => '666', :region => '3', :keys => '4321')
      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=555&name=foo&region_id=3&size_id=666&ssh_key_ids=4321")).to have_been_made
    end
  end


end

