require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "regions" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/v2/regions?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_regions"), :headers => {'Content-Type' => 'application/json'},)

      @cli.regions

      expect($stdout.string).to eq <<-eos
Regions:
New York 1 (slug: nyc1)
Amsterdam 1 (slug: ams1)
San Francisco 1 (slug: sfo1)
New York 2 (slug: nyc2)
Amsterdam 2 (slug: ams2)
Singapore 1 (slug: sgp1)
London 1 (slug: lon1)
New York 3 (slug: nyc3)
Amsterdam 3 (slug: ams3)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/v2/regions?per_page=200")).
        to have_been_made
    end
  end
end
