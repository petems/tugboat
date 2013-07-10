require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "droplets" do
    it "shows a list when droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
test222 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
test223 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
foo (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "returns an error when no droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_empty"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
You don't appear to have any droplets.
Try creating one with \e[32m`tugboat create`
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

end

