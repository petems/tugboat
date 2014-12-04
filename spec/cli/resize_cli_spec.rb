require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "resize" do
    it "resizes a droplet with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      stub_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.options = @cli.options.merge(:size => 123)
      @cli.resize("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing resize for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123")).
        to have_been_made
    end

    it "resizes a droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplet"))
      stub_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.options = @cli.options.merge(:size => 123, :id => 100823)
      @cli.resize

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Queuing resize for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123")).
        to have_been_made
    end

    it "resizes a droplet with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      stub_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.options = @cli.options.merge(:size => 123, :name => "foo")
      @cli.resize

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing resize for 100823 (foo)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123")).
        to have_been_made
    end

    it "raises SystemExit when a request fails" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => fixture("show_droplets"))
      stub_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123").
        to_return(:headers => {'Content-Type' => 'application/json'}, :status => 500, :body => '{"status":"ERROR","message":"Some error"}')

      @cli.options = @cli.options.merge(:size => 123)
      expect { @cli.resize("foo") }.to raise_error(SystemExit)

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823/resize?api_key=#{api_key}&client_id=#{client_key}&size_id=123")).
        to have_been_made
    end
  end
end
