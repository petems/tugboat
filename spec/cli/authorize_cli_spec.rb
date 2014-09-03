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
      $stdout.should_receive(:print).with("Enter your default region ID (optional, defaults to 1 (New York)): ")
      $stdin.should_receive(:gets).and_return(region)
      $stdout.should_receive(:print).with("Enter your default image ID (optional, defaults to 3240036 (Ubuntu 14.04 x64)): ")
      $stdin.should_receive(:gets).and_return(image)
      $stdout.should_receive(:print).with("Enter your default size ID (optional, defaults to 66 (512MB)): ")
      $stdin.should_receive(:gets).and_return(size)
      $stdout.should_receive(:print).with("Enter your default ssh key ID (optional, defaults to none): ")
      $stdin.should_receive(:gets).and_return(ssh_key_id)
      $stdout.should_receive(:print).with("Enter your default for private networking (optional, defaults to false): ")
      $stdin.should_receive(:gets).and_return(private_networking)
      $stdout.should_receive(:print).with("Enter your default for enabling backups (optional, defaults to false): ")
      $stdin.should_receive(:gets).and_return(backups_enabled)

      @cli.authorize

      expect($stdout.string).to include("Note: You can get this information from https://cloud.digitalocean.com/api_access")
      expect($stdout.string).to include("Also Note: Tugboat is setup to work with v1 of the Digital Ocean API (https://developers.digitalocean.com/v1/regions/)")
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include("Defaults can be changed at any time in your ~/.tugboat configuration file.")

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      config = YAML.load_file(tmp_path)

      config["defaults"]["image"].should eq image
      config["defaults"]["region"].should eq region
      config["defaults"]["size"].should eq size
      config["ssh"]["ssh_user"].should eq ssh_user
      config["ssh"]["ssh_key_path"].should eq ssh_key_path
      config["ssh"]["ssh_port"].should eq ssh_port
      config["defaults"]["ssh_key"].should eq ssh_key_id
      config["defaults"]["private_networking"].should eq private_networking
      config["defaults"]["backups_enabled"].should eq backups_enabled
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
      $stdout.should_receive(:print).with("Enter your default region ID (optional, defaults to 1 (New York)): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default image ID (optional, defaults to 3240036 (Ubuntu 14.04 x64)): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default size ID (optional, defaults to 66 (512MB)): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default ssh key ID (optional, defaults to none): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default for private networking (optional, defaults to false): ")
      $stdin.should_receive(:gets).and_return('')
      $stdout.should_receive(:print).with("Enter your default for enabling backups (optional, defaults to false): ")
      $stdin.should_receive(:gets).and_return('')

      @cli.authorize

      expect($stdout.string).to include("Note: You can get this information from https://cloud.digitalocean.com/api_access")
      expect($stdout.string).to include("Also Note: Tugboat is setup to work with v1 of the Digital Ocean API (https://developers.digitalocean.com/v1/regions/)")
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include("Defaults can be changed at any time in your ~/.tugboat configuration file.")

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      config = YAML.load_file(tmp_path)

      config["defaults"]["image"].should eq "3240036"
      config["defaults"]["region"].should eq "1"
      config["defaults"]["size"].should eq "66"
      config["ssh"]["ssh_user"].should eq ENV["USER"]
      config["ssh"]["ssh_key_path"].should eq "~/.ssh/id_rsa2"
      config["ssh"]["ssh_port"].should eq "22"
      config["defaults"]["ssh_key"].should eq ""
    end
  end

end

