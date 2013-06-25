require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "passwordreset" do
    it "resets the root password given a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      stub_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.password_reset("foo")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end

    it "resets the root password given an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplet"))
      stub_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.options = @cli.options.merge(:id => 100823)
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/100823?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end

    it "resets the root password given a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      stub_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => '{"status":"OK","event_id":456}')

      @cli.options = @cli.options.merge(:name => "foo")
      @cli.password_reset

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)
Queuing password reset for 100823 (foo)...done
Your new root password will be emailed to you
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end

    it "raises SystemExit when a request fails" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 200, :body => fixture("show_droplets"))
      stub_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}").
        to_return(:status => 500, :body => '{"status":"ERROR","message":"Some error"}')

      expect { @cli.password_reset("foo") }.to raise_error(SystemExit)

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/password_reset?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end
  end
end
