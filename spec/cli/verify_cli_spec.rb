require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "verify" do
    it "returns confirmation text when verify passes" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200)
      @cli.verify
      expect($stdout.string).to eq "Authentication with DigitalOcean was successful.\n"
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "returns error string when verify fails" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:headers => {'Content-Type' => 'application/json'}, :status => 401, :body => '{"status":"ERROR", "error_message":"Access Denied"}')
      expect { @cli.verify }.to raise_error(SystemExit)
      expect($stdout.string).to eq "\e[31mthe server responded with status 401!\e[0m\n\n\e[31mAccess Denied\e[0m\n\nDouble-check your parameters and configuration (in your ~/.tugboat file)\n"
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "returns error string when verify fails and a non-json reponse is given" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 401, :body => fixture('500','html'))
      expect { @cli.verify }.to raise_error(SystemExit)
      expect($stdout.string).to eq "\e[31mthe server responded with status 401!\e[0m\n\n\e[31mAccess Denied\e[0m\n\nDouble-check your parameters and configuration (in your ~/.tugboat file)\n"
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

  end

end

