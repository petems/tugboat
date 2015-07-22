require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "show" do
    it "shows an image with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/v2/images/12438838?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_redmine_image"))

      @cli.info_image("Redmine")

      expect($stdout.string).to eq <<-eos
Image fuzzy name provided. Finding image ID...done\e[0m, 12438838 (Redmine on 14.04)

Name:             Redmine on 14.04
ID:               12438838
Distribution:     Ubuntu
      eos

      # expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      # expect(a_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "shows an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/v2/images/12438838?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_redmine_image"))

      @cli.options = @cli.options.merge(:id => 12438838)
      @cli.info_image

      expect($stdout.string).to eq <<-eos
Image id provided. Finding Image...done\e[0m, 12438838 (Redmine on 14.04)

Name:             Redmine on 14.04
ID:               12438838
Distribution:     Ubuntu
      eos
    end

    it "shows an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/v2/images/12438838?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_redmine_image"))

      @cli.options = @cli.options.merge(:name => "Redmine on 14.04")
      @cli.info_image

      expect($stdout.string).to eq <<-eos
Image name provided. Finding Image...done\e[0m, 12438838 (Redmine on 14.04)

Name:             Redmine on 14.04
ID:               12438838
Distribution:     Ubuntu
      eos
    end

  end

end
