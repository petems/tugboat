require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "sizes" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/sizes?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_sizes"))

      @cli.sizes

      expect($stdout.string).to eq <<-eos
Sizes:
Size 1 (id: 1)
Size 2 (id: 2)
Size 3 (id: 3)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/sizes?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end
  end
end
