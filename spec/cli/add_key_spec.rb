require 'spec_helper'
require 'fileutils'

describe Tugboat::CLI do
  include_context 'spec'

  let(:tmp_path) { project_path + '/tmp/tugboat' }
  let(:fake_home) { "#{project_path}/tmp" }

  before do
    File.open('id_dsa.pub', 'w') { |f| f.write('ssh-dss A456= user@host') }
  end

  after do
    File.delete('id_dsa.pub') if File.exist?('id_dsa.pub')
    File.delete("#{fake_home}/.ssh/id_rsa.pub") if File.exist?("#{fake_home}/.ssh/id_rsa.pub")
  end

  describe 'add-key' do
    it 'with a name and key string' do
      stub_request(:post, 'https://api.digitalocean.com/v2/account/keys').
        with(body: '{"name":"macbook_pro","public_key":"ssh-dss A123= user@host"}').
        to_return(status: 201, body: fixture('create_ssh_key'), headers: {})

      cli.options = cli.options.merge(key: ssh_public_key.to_s)

      add_key_with_name_and_keystring = <<-eos
Queueing upload of SSH key 'macbook_pro'...SSH Key uploaded

Name: macbook_pro
ID: 3
      eos

      expect { cli.add_key(ssh_key_name) }.to output(add_key_with_name_and_keystring).to_stdout

      expect(a_request(:post, 'https://api.digitalocean.com/v2/account/keys')).to have_been_made
    end

    before do
      allow(ENV).to receive(:[]).with('HOME').and_return(fake_home)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      FileUtils.mkdir_p "#{fake_home}/.ssh"
      File.open("#{fake_home}/.ssh/id_rsa.pub", 'w') { |f| f.write('ssh-dss A456= user@host') }
    end

    it 'with name, prompts from file folder' do
      stub_request(:post, 'https://api.digitalocean.com/v2/account/keys').
        with(body: '{"name":"macbook_pro","public_key":"ssh-dss A456= user@host"}',
             headers: { 'Accept' => '*/*', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json' }).
        to_return(status: 201, body: fixture('create_ssh_key_from_file'), headers: {})

      expect($stdin).to receive(:gets).and_return("#{fake_home}/.ssh/id_rsa.pub")

      with_name_prompts_from_file_folder_stdout = <<-eos
Possible public key paths from #{fake_home}/.ssh:

#{fake_home}/.ssh/id_rsa.pub

Enter the path to your SSH key: Queueing upload of SSH key 'macbook_pro'...SSH Key uploaded

Name: cool_key
ID: 5
      eos

      expect { cli.add_key(ssh_key_name) }.to output(with_name_prompts_from_file_folder_stdout).to_stdout
    end

    after do
      File.delete('id_dsa.pub') if File.exist?('id_dsa.pub')
      FileUtils.rm_rf("#{fake_home}/.ssh/") if File.exist?("#{fake_home}/.ssh/")
    end
  end
end
