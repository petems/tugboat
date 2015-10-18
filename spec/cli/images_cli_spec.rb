require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "images" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200&private=true").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => "", :headers => {})

      @cli.images

      expect($stdout.string).to eq <<-eos
Listing Your Images
(Use `tugboat images --global` to show all images)
My Images:
NYTD Backup 1-18-2012 (id: 466, distro: Ubuntu)
NLP Final (id: 478, distro: Ubuntu)
      eos
    end

    it "acknowledges when my images are empty" do
       stub_request(:get, "https://api.digitalocean.com/v2/images?filter=my_images&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => "", :headers => {})
      pending 'Waiting on https://github.com/boats/barge/issues/12'
      @cli.images

      expect($stdout.string).to eq <<-eos
Listing Your Images
(Use `tugboat images --global` to show all images)
My Images:
No images found
      eos
    end

    it "acknowledges when my images are empty and also shows a global list" do
       stub_request(:get, "https://api.digitalocean.com/v2/images?filter=my_images&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => "", :headers => {})
      pending 'Waiting on https://github.com/boats/barge/issues/12'
      @cli.options = @cli.options.merge(:global => true)
      @cli.images

      expect($stdout.string).to eq <<-eos
My Images:
No images found

Global Images:
NYTD Backup 1-18-2012 (id: 466, distro: Ubuntu)
NLP Final (id: 478, distro: Ubuntu)
Global Final (id: 479, distro: Ubuntu)
      eos
    end

    it "shows a global list" do
       stub_request(:get, "https://api.digitalocean.com/v2/images?filter=my_images&per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => "", :headers => {})

      pending 'Waiting on https://github.com/boats/barge/issues/12'
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
    end
  end

end

