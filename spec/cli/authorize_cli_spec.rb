require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  let(:tmp_path)             { project_path + "/tmp/tugboat" }

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
      $stdout.should_receive(:print).with("Enter your default region (optional, defaults to 1 (New York)): ")
      $stdin.should_receive(:gets).and_return(region)
      $stdout.should_receive(:print).with("Enter your default image (optional, defaults to 284203 (Ubuntu 12.04 x64)): ")
      $stdin.should_receive(:gets).and_return(image)
      $stdout.should_receive(:print).with("Enter your default size  (optional, defaults to 66 (512MB)): ")
      $stdin.should_receive(:gets).and_return(size)

      @cli.authorize

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      File.read(tmp_path).should include "image: '#{image}'", "region: '#{region}'", "size: '#{size}'", "ssh_user: #{ssh_user}", "ssh_key_path: #{ssh_key_path}", "ssh_port: '#{ssh_port}'"

    end

    it "sets defaults if no input given" do

      $stdout.should_receive(:print).exactly(6).times
      $stdout.should_receive(:print).with("Enter your client key: ")
      $stdin.should_receive(:gets).and_return(client_key)
      $stdout.should_receive(:print).with("Enter your API key: ")
      $stdin.should_receive(:gets).and_return(api_key)
      $stdout.should_receive(:print).with("Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ")
      $stdin.should_receive(:gets).and_return(ssh_key_path)
      $stdout.should_receive(:print).with("Enter your SSH user (optional, defaults to #{ENV['USER']}): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your SSH port number (optional, defaults to 22): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default region (optional, defaults to 1 (New York)): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default image (optional, defaults to 284203 (Ubuntu 12.04 x64)): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default size  (optional, defaults to 66 (512MB)): ")
      $stdin.should_receive(:gets).and_return('')

      @cli.authorize

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      File.read(tmp_path).should include "image: '284203'", "region: '1'", "size: '66'", "ssh_user: #{ENV['USER']}", "ssh_key_path: ~/.ssh/id_rsa", "ssh_port: '22'"

    end
  end

end

