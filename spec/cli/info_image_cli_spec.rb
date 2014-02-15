require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "show" do
    it "shows an image with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      @cli.info_image("NLP Final")

      expect($stdout.string).to eq <<-eos
Image fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\n\nName:             NLP Final\nID:               478\nDistribution:     Ubuntu
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "shows an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      @cli.options = @cli.options.merge(:id => 478)
      @cli.info_image

      expect($stdout.string).to eq <<-eos
Image id provided. Finding Image...done\e[0m, 478 (NLP Final)\n\nName:             NLP Final\nID:               478\nDistribution:     Ubuntu
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made.times(2)
    end

    it "shows an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      @cli.options = @cli.options.merge(:name => "NLP Final")
      @cli.info_image

      expect($stdout.string).to eq <<-eos
Image name provided. Finding image ID...done\e[0m, 478 (NLP Final)\n\nName:             NLP Final\nID:               478\nDistribution:     Ubuntu
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end
