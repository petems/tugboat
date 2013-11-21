require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "droplets" do
    it "shows a list when droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
\e[32mON \e[0m foo                            33.33.33.10     @ New York 1        #100823
\e[32mON \e[0m test222                        33.33.33.10     @ New York 1        #100823
\e[32mON \e[0m test223                        33.33.33.10     @ New York 1        #100823
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "returns an error when no droplets exist" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_empty"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
You don't appear to have any droplets.
Try creating one with \e[32m`tugboat create`\e[0m
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
    it "shows no output when --quiet is set" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets_empty"))

      @cli.options = @cli.options.merge(:quiet => true)
      @cli.droplets

      # Should be /dev/null not stringIO
      expect($stdout).to be_a File

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

end
