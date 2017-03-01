require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'config' do
    it 'shows the full config' do
      @cli.config

      expect($stdout.string).to eq <<-eos
Current Config\x20
Path: #{Dir.pwd}/tmp/tugboat
---
authentication:
  access_token: foo
ssh:
  ssh_user: baz
  ssh_key_path: ~/.ssh/id_rsa2
  ssh_port: '33'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: '1234'
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
      eos
    end

    it 'hides sensitive data if option given' do
      @cli.options = @cli.options.merge(hide: true)
      @cli.config

      expect($stdout.string).to eq <<-eos
Current Config (Keys Redacted)
Path: #{Dir.pwd}/tmp/tugboat
---
authentication:
  access_token:\x20\x20[REDACTED]
ssh:
  ssh_user: baz
  ssh_key_path: ~/.ssh/id_rsa2
  ssh_port: '33'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: '1234'
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
      eos
    end
  end
end
