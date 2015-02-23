require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "keys" do
    it "shows a list" do

      stub_request(:get, "https://api.digitalocean.com/v2/account/keys?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture('show_keys'), :headers => {})

      @cli.keys

      expect($stdout.string).to eq <<-eos
SSH Keys:
Name: My SSH Public Key, (id: 512189), fingerprint: 3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa
Name: My Other SSH Public Key, (id: 512110), fingerprint: 3b:16:bf:d4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa
      eos

      expect(a_request(:get, "https://api.digitalocean.com/v2/account/keys?per_page=200")).to have_been_made
    end
  end
end

