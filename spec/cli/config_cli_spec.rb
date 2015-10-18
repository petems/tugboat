require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "config" do
    it "shows the full config" do

      @cli.config

      expect($stdout.string).to eq <<-eos
Current Config\x20
Path: #{Dir.pwd}/tmp/tugboat
---
authentication:
  client_key: foo
  api_key: bar
ssh:
  ssh_user: baz
  ssh_key_path: ~/.ssh/id_rsa2
  ssh_port: '33'
defaults:
  region: '3'
  image: '345791'
  size: '67'
  ssh_key: '1234'
  private_networking: 'false'
  backups_enabled: 'false'
      eos
    end

    it "hides sensitive data if option given" do

      @cli.options = @cli.options.merge(:hide => true)
      @cli.config

            expect($stdout.string).to eq <<-eos
Current Config (Keys Redacted)
Path: #{Dir.pwd}/tmp/tugboat
---
authentication:
  client_key:\x20\x20[REDACTED]
  api_key:\x20\x20[REDACTED]
ssh:
  ssh_user: baz
  ssh_key_path: ~/.ssh/id_rsa2
  ssh_port: '33'
defaults:
  region: '3'
  image: '345791'
  size: '67'
  ssh_key: '1234'
  private_networking: 'false'
  backups_enabled: 'false'
      eos
    end
  end
end

