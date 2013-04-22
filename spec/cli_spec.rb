require 'spec_helper'

describe Tugboat::CLI do
  $stdout.sync = true
  $stderr.sync = true

  let(:config) { Tugboat::Configuration.instance }
  let(:client_key)       { "foo" }
  let(:api_key)          { "bar" }
  let(:ssh_user)         { "baz" }
  let(:ssh_key_path)     { "~/.ssh/id_rsa2" }
  let(:droplet_name)     { "foo" }
  let(:droplet_id)       { 1234 }

  before :each do
    config.path = project_path + "/tmp/tugboat"
    config.create_config_file(client_key, api_key, ssh_user, ssh_key_path)
    @cli = Tugboat::CLI.new
    @orig_stderr = $stderr
    @orig_stdout = $stdout
    $stderr = StringIO.new
    $stdout = StringIO.new
  end

  after :each do
    $stderr = @orig_stderr
    $stdout = @orig_stdout
  end

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

      @cli.authorize

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end


  describe "create a droplet" do
    it "with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id&name=#{droplet_name}&region_id&size_id&ssh_key_ids").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos
      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id&name=#{droplet_name}&region_id&size_id&ssh_key_ids")).to have_been_made
    end

    it "with args" do
      stub_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=2672&name=#{droplet_name}&region_id=2&size_id=64&ssh_key_ids=1234").
         to_return(:status => 200, :body => '{"status":"OK"}')

      @cli.options = @cli.options.merge(:image => 2672, :size => 64, :region => 2, :keys => "1234")
      @cli.create(droplet_name)

      expect($stdout.string).to eq <<-eos
Queueing creation of droplet '#{droplet_name}'...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets/new?api_key=#{api_key}&client_id=#{client_key}&image_id=2672&name=foo&region_id=2&size_id=64&ssh_key_ids=1234")).to have_been_made
    end
  end

  describe "droplets" do
    it "shows a list" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.droplets

      expect($stdout.string).to eq <<-eos
test222 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
test223 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
test224 (ip: 33.33.33.10, status: \e[31moff\e[0m, region: 1, id: 100823)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

  describe "show" do
    it "shows a droplet with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.info

      expect($stdout.string).to eq <<-eos
test222 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
test223 (ip: 33.33.33.10, status: \e[32mactive\e[0m, region: 1, id: 100823)
test224 (ip: 33.33.33.10, status: \e[31moff\e[0m, region: 1, id: 100823)
      eos

      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end


end

