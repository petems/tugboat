require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "destroy" do
    it "destroys a droplet with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:delete, "https://api.digitalocean.com/v2/droplets/6918990").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 204, :body => "", :headers => {})

      expect($stdin).to receive(:gets).and_return("y")

      @cli.destroy("example.com")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
eos
    end

    it "destroys a droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets/6918990?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplet'), :headers => {})

      stub_request(:delete, "https://api.digitalocean.com/v2/droplets/6918990").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 204, :body => "", :headers => {})

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => '6918990')
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos
    end


    it "destroys a droplet with a name" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
      to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:delete, "https://api.digitalocean.com/v2/droplets/6918990").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
      to_return(:status => 204, :body => "", :headers => {})

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => 'example.com')
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos
    end

    it "destroys a droplet with confirm flag set" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      stub_request(:delete, "https://api.digitalocean.com/v2/droplets/6918990").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 204, :body => "", :headers => {})

      @cli.options = @cli.options.merge(:name => 'example.com', :confirm => true)
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
Queuing destroy for 6918990 (example.com)...Deletion Successful!
      eos
    end

    it "does not destroy a droplet if no is chosen" do
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})

      $stdin.should_receive(:gets).and_return("n")

      expect {@cli.destroy("example.com")}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)\nWarning! Potentially destructive action. Please confirm [y/n]: Aborted due to user request.
      eos
    end
  end

end
