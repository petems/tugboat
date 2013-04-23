require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "regions" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/regions?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_regions"))

      @cli.regions

      expect($stdout.string).to eq <<-eos
Regions:
Region 1 (id: 1)
Region 2 (id: 2)
Region 3 (id: 3)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/regions?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end
  end
end
