require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "keys" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/ssh_keys?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_keys"))

      @cli.keys

      expect($stdout.string).to eq <<-eos
SSH Keys:
office-imac (id: 10)
macbook-air (id: 11)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end
end

