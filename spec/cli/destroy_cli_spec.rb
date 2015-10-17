require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "destroy" do
    it "destroys a droplet with a fuzzy name" do
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      stub_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.destroy("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "destroys a droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      stub_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "destroys a droplet with a name" do
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      stub_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "destroys a droplet with confirm flag set" do
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      stub_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.options = @cli.options.merge(:confirm => true)
      @cli.destroy

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing destroy for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "does not destroy a droplet if no is chosen" do
stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_droplets'), :headers => {})
      stub_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      $stdin.should_receive(:gets).and_return("n")

      expect {@cli.destroy("foo")}.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nWarning! Potentially destructive action. Please confirm [y/n]: Aborted due to user request.
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:delete, "https://api.digitalocean.com/droplets/100823/destroy?api_key=#{api_key}&client_id=#{client_key}")).to_not have_been_made
    end
  end

end
