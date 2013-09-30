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

      stub_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}").
      to_return(:status => 200, :body => fixture("create_ssh_key"))

      @cli.options = @cli.options.merge(:key => "#{ssh_public_key}")
      @cli.add_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Queueing upload of SSH key '#{ssh_key_name}'...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}")).to have_been_made
    end

    before :each do
      ENV.stub(:[]).with('HOME').and_return(fake_home)
      ENV.stub(:[]).with('DEBUG').and_return(nil)
      ENV.stub(:[]).with('http_proxy').and_return(nil)
      FileUtils.mkdir_p "#{fake_home}/.ssh"
      File.open("#{fake_home}/.ssh/id_rsa.pub", 'w') {|f| f.write("ssh-dss A456= user@host") }
    end

    it "with name, prompts from file folder" do
      stub_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=ssh-dss%20A456=%20user@host").
      to_return(:status => 200, :body => fixture("create_ssh_key"))

      $stdout.should_receive(:print).exactly(4).times
      $stdout.should_receive(:print).with("Enter the path to your SSH key: ")
      $stdout.should_receive(:print).with("Queueing upload of SSH key '#{ssh_key_name}'...")
      $stdin.should_receive(:gets).and_return("#{fake_home}/.ssh/id_rsa.pub")

      @cli.add_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Possible public key paths from #{fake_home}/.ssh:

#{fake_home}/.ssh/id_rsa.pub

done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=ssh-dss%20A456=%20user@host")).to have_been_made
    end

    after :each do
      File.delete("id_dsa.pub") if File.exist?("id_dsa.pub")
      FileUtils.rm_rf("#{fake_home}/.ssh/") if File.exist?("#{fake_home}/.ssh/")
    end

  end
end

