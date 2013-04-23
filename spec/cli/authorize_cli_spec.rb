require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    @cli = Tugboat::CLI.new
  end

  describe "authorize" do
    before do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200)
    end

    it "asks the right questions and checks credentials" do

      $stdout.should_receive(:print).exactly(6).times
      $stdout.should_receive(:print).with("Enter your client key: ")
      $stdin.should_receive(:gets).and_return(client_key)
      $stdout.should_receive(:print).with("Enter your API key: ")
      $stdin.should_receive(:gets).and_return(api_key)
      $stdout.should_receive(:print).with("Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ")
      $stdin.should_receive(:gets).and_return(ssh_key_path)
      $stdout.should_receive(:print).with("Enter your SSH user (optional, defaults to #{ENV['USER']}): ")
      $stdin.should_receive(:gets).and_return(ssh_user)
      $stdout.should_receive(:print).with("Enter your SSH port number (optional, defaults to 22): ")
      $stdin.should_receive(:gets).and_return(ssh_port)

      @cli.authorize

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

end

