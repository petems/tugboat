require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "regions" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/regions?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_regions"))

      @cli.regions

      expect($stdout.string).to eq <<-eos
Regions:
Region 1 (id: 1) (slug: reg1)
Region 2 (id: 2) (slug: reg2)
Region 3 (id: 3) (slug: reg3)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/regions?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end
  end
end
