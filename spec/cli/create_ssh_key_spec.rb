require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "upload an ssh key" do
    it "with a name" do

      stub_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}").
      to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.options = @cli.options.merge(:key => "#{ssh_public_key}")
      @cli.upload_ssh_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Queueing upload of ssh key '#{ssh_key_name}'...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}")).to have_been_made
    end

  end
end

