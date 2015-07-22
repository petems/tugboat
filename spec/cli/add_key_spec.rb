require 'spec_helper'
require 'fileutils'

describe Tugboat::CLI do
  include_context "spec"

  let(:tmp_path) { project_path + "/tmp/tugboat" }
  let(:fake_home) { "#{project_path}/tmp" }

  before :each do
    File.open("id_dsa.pub", 'w') {|f| f.write("ssh-dss A456= user@host") }
  end

  after :each do
    File.delete("id_dsa.pub") if File.exist?("id_dsa.pub")
    File.delete("#{fake_home}/.ssh/id_rsa.pub") if File.exist?("#{fake_home}/.ssh/id_rsa.pub")
  end

  describe "add-key" do
    it "with a name and key string" do

      stub_request(:post, "https://api.digitalocean.com/v2/account/keys").
         with(:body => "{\"name\":\"macbook_pro\",\"public_key\":\"ssh-dss A123= user@host\"}").
         to_return(:status => 201, :body => fixture('create_ssh_key'), :headers => {})

      @cli.options = @cli.options.merge(:key => "#{ssh_public_key}")
      @cli.add_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Queueing upload of SSH key 'macbook_pro'...SSH Key uploaded

Name: macbook_pro
ID: 3
      eos

      expect(a_request(:post, "https://api.digitalocean.com/v2/account/keys")).to have_been_made
    end

    before :each do
      allow(ENV).to receive(:[]).with('HOME').and_return(fake_home)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      FileUtils.mkdir_p "#{fake_home}/.ssh"
      File.open("#{fake_home}/.ssh/id_rsa.pub", 'w') {|f| f.write("ssh-dss A456= user@host") }
    end

    it "with name, prompts from file folder" do
      stub_request(:post, "https://api.digitalocean.com/v2/account/keys").
         with(:body => "{\"name\":\"macbook_pro\",\"public_key\":\"ssh-dss A456= user@host\"}",
              :headers => {'Accept'=>'*/*', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json'}).
         to_return(:status => 201, :body => fixture('create_ssh_key_from_file'), :headers => {})

      expect($stdout).to receive(:print).exactly(4).times
      expect($stdout).to receive(:print).with("Enter the path to your SSH key: ")
      expect($stdout).to receive(:print).with("Queueing upload of SSH key '#{ssh_key_name}'...")
      expect($stdin).to receive(:gets).and_return("#{fake_home}/.ssh/id_rsa.pub")

      @cli.add_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Possible public key paths from #{fake_home}/.ssh:

#{fake_home}/.ssh/id_rsa.pub

SSH Key uploaded

Name: cool_key
ID: 5
      eos
    end

    after :each do
      File.delete("id_dsa.pub") if File.exist?("id_dsa.pub")
      FileUtils.rm_rf("#{fake_home}/.ssh/") if File.exist?("#{fake_home}/.ssh/")
    end

  end
end

