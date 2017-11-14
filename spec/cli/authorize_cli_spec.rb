require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  let(:tmp_path) { project_path + '/tmp/tugboat' }

  describe 'authorize' do
    before do
    end

    it 'asks the right questions and checks credentials' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      expect($stdout).to receive(:print).exactly(6).times
      expect($stdout).to receive(:print).with('Enter your access token: ')
      expect($stdin).to receive(:gets).and_return(access_token)
      expect($stdout).to receive(:print).with('Enter your default timeout for connections in seconds (optional, defaults to 10): ')
      expect($stdin).to receive(:gets).and_return(timeout)
      expect($stdout).to receive(:print).with('Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ')
      expect($stdin).to receive(:gets).and_return(ssh_key_path)
      expect($stdout).to receive(:print).with('Enter your SSH user (optional, defaults to root): ')
      expect($stdin).to receive(:gets).and_return(ssh_user)
      expect($stdout).to receive(:print).with('Enter your SSH port number (optional, defaults to 22): ')
      expect($stdin).to receive(:gets).and_return(ssh_port)
      expect($stdout).to receive(:print).with('Enter your default region (optional, defaults to nyc1): ')
      expect($stdin).to receive(:gets).and_return(region)
      expect($stdout).to receive(:print).with('Enter your default image ID or image slug (optional, defaults to ubuntu-14-04-x64): ')
      expect($stdin).to receive(:gets).and_return(image)
      expect($stdout).to receive(:print).with('Enter your default size (optional, defaults to 512mb)): ')
      expect($stdin).to receive(:gets).and_return(size)
      expect($stdout).to receive(:print).with("Enter your default ssh key IDs (optional, defaults to none, array of IDs of ssh keys eg. ['1234']): ")
      expect($stdin).to receive(:gets).and_return(ssh_key_id)
      expect($stdout).to receive(:print).with('Enter your default for private networking (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return(private_networking)
      expect($stdout).to receive(:print).with('Enter your default for enabling backups (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return(backups_enabled)
      expect($stdout).to receive(:print).with('Enter your default for IPv6 (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return(ip6)

      cli.authorize

      expect($stdout.string).to include('Note: You can get your Access Token from https://cloud.digitalocean.com/settings/tokens/new')
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include('Defaults can be changed at any time in your ~/.tugboat configuration file.')

      config = YAML.load_file(tmp_path)

      expect(config['defaults']['image']).to eq image
      expect(config['defaults']['region']).to eq region
      expect(config['defaults']['size']).to eq size
      expect(config['ssh']['ssh_user']).to eq ssh_user
      expect(config['ssh']['ssh_key_path']).to eq ssh_key_path
      expect(config['ssh']['ssh_port']).to eq ssh_port
      expect(config['defaults']['ssh_key']).to eq ssh_key_id
      expect(config['defaults']['private_networking']).to eq private_networking
      expect(config['defaults']['backups_enabled']).to eq backups_enabled
      expect(config['defaults']['ip6']).to eq ip6
    end

    it 'sets defaults if no input given' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => %r{Bearer}, 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      expect($stdout).to receive(:print).exactly(6).times
      expect($stdout).to receive(:print).with('Enter your access token: ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default timeout for connections in seconds (optional, defaults to 10): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your SSH user (optional, defaults to root): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your SSH port number (optional, defaults to 22): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default region (optional, defaults to nyc1): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default image ID or image slug (optional, defaults to ubuntu-14-04-x64): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default size (optional, defaults to 512mb)): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with("Enter your default ssh key IDs (optional, defaults to none, array of IDs of ssh keys eg. ['1234']): ")
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default for private networking (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default for enabling backups (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return('')
      expect($stdout).to receive(:print).with('Enter your default for IPv6 (optional, defaults to false): ')
      expect($stdin).to receive(:gets).and_return('')

      cli.authorize

      expect($stdout.string).to include('Note: You can get your Access Token from https://cloud.digitalocean.com/settings/tokens/new')
      expect($stdout.string).to include("To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.")
      expect($stdout.string).to include('Defaults can be changed at any time in your ~/.tugboat configuration file.')

      config = YAML.load_file(tmp_path)

      expect(config['defaults']['image']).to eq 'ubuntu-14-04-x64'
      expect(config['defaults']['region']).to eq 'nyc2'
      expect(config['defaults']['size']).to eq '512mb'
      expect(config['ssh']['ssh_user']).to eq 'root'
      expect(config['ssh']['ssh_key_path']).to eq '~/.ssh/id_rsa'
      expect(config['ssh']['ssh_port']).to eq '22'
      expect(config['defaults']['ssh_key']).to eq ''
      expect(config['defaults']['private_networking']).to eq 'false'
      expect(config['defaults']['backups_enabled']).to eq 'false'
      expect(config['defaults']['ip6']).to eq 'false'
    end
  end
end
