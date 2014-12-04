require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "restarts a droplet" do
    it "with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))

      stub_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      @cli.restart("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing restart for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "restarts a droplet hard when the hard option is used" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      stub_request(:put, "https://api.digitalocean.com/droplets/100823/power_cycle?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:hard => true)
      @cli.restart("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing hard restart for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/power_cycle?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      stub_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.restart

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Queuing restart for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))

      stub_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.restart

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing restart for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:put, "https://api.digitalocean.com/droplets/100823/reboot?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end
