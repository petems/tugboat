require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  before :each do
    File.open("id_dsa.pub", 'w') {|f| f.write("ssh-dss A456= user@host") }
  end

  after :each do
    File.delete("id_dsa.pub") if File.exist?("id_dsa.pub")
  end

  describe "add-key" do
    it "with a name and key string" do

      stub_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}").
      to_return(:status => 200, :body => fixture("create_ssh_key"))

      @cli.options = @cli.options.merge(:key => "#{ssh_public_key}")
      @cli.add_key(ssh_key_name)

      expect($stdout.string).to eq <<-eos
Queueing upload of ssh key '#{ssh_key_name}'...
Done!
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=#{ssh_public_key}")).to have_been_made
    end

    it "with name, prompts from file folder" do

      stub_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=ssh-dss%20A456=%20user@host").
      to_return(:status => 200, :body => fixture("create_ssh_key"))

      $stdout.should_receive(:print).exactly(4).times
      $stdout.should_receive(:print).with("Choose a file path to use from the list above: ")
      $stdin.should_receive(:gets).and_return('id_dsa.pub')

      expect($stdout.string).to eq <<-eos
No pub key string given, I'm going to suggest some from your ~/.ssh folder
/home/foo/.ssh/id_rsa.pub
Queueing upload of ssh key '#{ssh_key_name}'...
Done!
      eos

      expect(a_request(:get, "https://api.digitalocean.com/ssh_keys/new?api_key=#{api_key}&client_id=#{client_key}&name=#{ssh_key_name}&ssh_pub_key=ssh-dss%20A456=%20user@host")).to have_been_made
    end

  end
end

