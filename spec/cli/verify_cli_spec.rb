require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "verify" do
    it "returns confirmation text when verify passes" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:status => 200, :body => fixture("show_droplets"), :headers => {'Content-Type' => 'application/json'},)

      @cli.verify
      expect($stdout.string).to eq "Authentication with DigitalOcean was successful.\n"
      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end

    it "returns error when verify fails" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(:headers => {'Content-Type' => 'text/html'}, :status => 500, :body => fixture('500','html'))

      expect { @cli.verify }.to raise_error(SystemExit)
      expect($stdout.string).to include "Authentication with DigitalOcean failed."
      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end

    it "returns error string when verify fails and a non-json reponse is given" do
      pending("Requires faraday config exposure from Barge")

      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(:headers => {'Content-Type' => 'text/html'}, :status => 500, :body => fixture('500','html'))

      expect { @cli.verify }.to raise_error(SystemExit)
      expect($stdout.string).to eq "\e[31mthe server responded with status 500!\e[0m\n"
      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).to have_been_made
    end

  end

end

