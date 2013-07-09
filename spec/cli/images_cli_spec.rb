require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "images" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images").
           to_return(:status => 200, :body => fixture("show_images"))

      @cli.images

      expect($stdout.string).to eq <<-eos
My Images:
NYTD Backup 1-18-2012 (id: 466, distro: Ubuntu)
NLP Final (id: 478, distro: Ubuntu)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images")).to have_been_made
    end

    it "shows an error response when images empty " do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images").
      to_return(:status => 200, :body => fixture("show_images_empty"))

      @cli.images

      expect($stdout.string).to eq <<-eos
My Images:
No images found
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images")).to have_been_made
    end

    it "shows a global list" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=global").
           to_return(:status => 200, :body => fixture("show_images_global"))

      @cli.options = @cli.options.merge(:global => true)
      @cli.images

      expect($stdout.string).to eq <<-eos
My Images:
NYTD Backup 1-18-2012 (id: 466, distro: Ubuntu)
NLP Final (id: 478, distro: Ubuntu)

Global Images:
NYTD Backup 1-18-2012 (id: 466, distro: Ubuntu)
NLP Final (id: 478, distro: Ubuntu)
Global Final (id: 479, distro: Ubuntu)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=my_images")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}&filter=global")).to have_been_made
    end
  end

end

