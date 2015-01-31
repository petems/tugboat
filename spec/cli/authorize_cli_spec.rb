require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  let(:tmp_path)             { project_path + "/tmp/tugboat" }

  describe "authorize" do
    before do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
      to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200)
    end

    it "asks the right questions and checks credentials" do

      expect($stdout).to receive(:print).exactly(6).times
      expect($stdout).to receive(:print).with("Enter your client key: ")
      expect($stdin).to receive(:gets).and_return(client_key)
      expect($stdout).to receive(:print).with("Enter your API key: ")
      expect($stdin).to receive(:gets).and_return(api_key)
      expect($stdout).to receive(:print).with("Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ")
      expect($stdin).to receive(:gets).and_return(ssh_key_path)
      expect($stdout).to receive(:print).with("Enter your SSH user (optional, defaults to #{ENV['USER']}): ")
      expect($stdin).to receive(:gets).and_return(ssh_user)
      expect($stdout).to receive(:print).with("Enter your SSH port number (optional, defaults to 22): ")
      expect($stdin).to receive(:gets).and_return(ssh_port)
      expect($stdout).to receive(:print).with("Enter your default region ID (optional, defaults to 8 (New York)): ")
      expect($stdin).to receive(:gets).and_return(region)
      expect($stdout).to receive(:print).with("Enter your default image ID (optional, defaults to 9801950 (Ubuntu 14.04 x64)): ")
      expect($stdin).to receive(:gets).and_return(image)
      expect($stdout).to receive(:print).with("Enter your default size ID (optional, defaults to 66 (512MB)): ")
      expect($stdin).to receive(:gets).and_return(size)
      expect($stdout).to receive(:print).with("Enter your default ssh key ID (optional, defaults to none): ")
      expect($stdin).to receive(:gets).and_return(ssh_key_id)
      expect($stdout).to receive(:print).with("Enter your default for private networking (optional, defaults to false): ")
      expect($stdin).to receive(:gets).and_return(private_networking)
      expect($stdout).to receive(:print).with("Enter your default for enabling backups (optional, defaults to false): ")
      expect($stdin).to receive(:gets).and_return(backups_enabled)

      @cli.authorize

      expect($stdout.string).to include("Note: You can get this information from https://cloud.digitalocean.com/api_access")
      expect($stdout.string).to include("Also Note: Tugboat is setup to work with v1 of the Digital Ocean API (https://developers.digitalocean.com/v1/regions/)")
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include("Defaults can be changed at any time in your ~/.tugboat configuration file.")

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      config = YAML.load_file(tmp_path)

      expect(config["defaults"]["image"]).to eq image
      expect(config["defaults"]["region"]).to eq region
      expect(config["defaults"]["size"]).to eq size
      expect(config["ssh"]["ssh_user"]).to eq ssh_user
      expect(config["ssh"]["ssh_key_path"]).to eq ssh_key_path
      expect(config["ssh"]["ssh_port"]).to eq ssh_port
      expect(config["defaults"]["ssh_key"]).to eq ssh_key_id
      expect(config["defaults"]["private_networking"]).to eq private_networking
      expect(config["defaults"]["backups_enabled"]).to eq backups_enabled
    end

    it "sets defaults if no input given" do

      expect($stdout).to receive(:print).exactly(6).times
      expect($stdout).to receive(:print).with("Enter your client key: ")
      expect($stdin).to receive(:gets).and_return(client_key)
      expect($stdout).to receive(:print).with("Enter your API key: ")
      expect($stdin).to receive(:gets).and_return(api_key)
      expect($stdout).to receive(:print).with("Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ")
      expect($stdin).to receive(:gets).and_return(ssh_key_path)
      expect($stdout).to receive(:print).with("Enter your SSH user (optional, defaults to #{ENV['USER']}): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your SSH port number (optional, defaults to 22): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default region ID (optional, defaults to 8 (New York)): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default image ID (optional, defaults to 9801950 (Ubuntu 14.04 x64)): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default size ID (optional, defaults to 66 (512MB)): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default ssh key ID (optional, defaults to none): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default for private networking (optional, defaults to false): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default for enabling backups (optional, defaults to false): ")
      expect($stdin).to receive(:gets).and_return('')

      @cli.authorize

      expect($stdout.string).to include("Note: You can get this information from https://cloud.digitalocean.com/api_access")
      expect($stdout.string).to include("Also Note: Tugboat is setup to work with v1 of the Digital Ocean API (https://developers.digitalocean.com/v1/regions/)")
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include("Defaults can be changed at any time in your ~/.tugboat configuration file.")

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made

      config = YAML.load_file(tmp_path)

      expect(config["defaults"]["image"]).to eq "9801950"
      expect(config["defaults"]["region"]).to eq "8"
      expect(config["defaults"]["size"]).to eq "66"
      expect(config["ssh"]["ssh_user"]).to eq 'root'
      expect(config["ssh"]["ssh_key_path"]).to eq "~/.ssh/id_rsa2"
      expect(config["ssh"]["ssh_port"]).to eq "22"
      expect(config["defaults"]["ssh_key"]).to eq ""
    end
  end

end

