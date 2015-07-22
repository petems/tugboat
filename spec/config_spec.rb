require 'spec_helper'

describe Tugboat::Configuration do
  include_context "spec"

  let(:tmp_path)             { project_path + "/tmp/tugboat" }

  after :each do
    # Clean up the temp file.
    File.delete(project_path + "/tmp/tugboat") if File.exist?(project_path + "/tmp/tugboat")
  end

  it "is a singleton" do
    expect(Tugboat::Configuration).to be_a Class
    expect do
      Tugboat::Configuration.new
    end.to raise_error(NoMethodError, /private method `new' called/)
  end

  it "has a data attribute" do
    config = Tugboat::Configuration.instance
    expect(config.data).to be
  end

  describe "the file" do
    let(:access_token)       { "foo" }
    let(:ssh_user)           { "root" }
    let(:ssh_key_path)       { "~/.ssh/id_rsa2" }
    let(:ssh_port)           { "22" }
    let(:region)             { "lon1" }
    let(:image)              { "ubuntu-14-04-x64" }
    let(:size)               { "512mb" }
    let(:ssh_key_id)         { '1234' }
    let(:private_networking) { 'false' }
    let(:backups_enabled)    { 'false' }

    let(:config)           { config = Tugboat::Configuration.instance }

    before :each do
      # Create a temporary file
      config.create_config_file(access_token, ssh_key_path, ssh_user, ssh_port, region, image, size, ssh_key_id, private_networking, backups_enabled)
    end

    it "can be created" do
      expect(File.exist?(tmp_path)).to be_true
    end

    it "can be loaded" do
      data = config.load_config_file
      expect(data).to_not be_nil
    end

    describe "the file format"
    let(:data)  { YAML.load_file(tmp_path) }

    it "should have authentication at the top level" do
      expect(data).to have_key("authentication")
    end

    it "should have ssh at the top level" do
      expect(data).to have_key("ssh")
    end

    it "should have an access token" do
      auth = data["authentication"]
      expect(auth).to have_key("access_token")
    end

    it "should have an ssh key path" do
      ssh = data["ssh"]
      expect(ssh).to have_key("ssh_key_path")
    end

    it "should have an ssh user" do
      ssh = data["ssh"]
      expect(ssh).to have_key("ssh_user")
    end

    it "should have an ssh port" do
      ssh = data["ssh"]
      expect(ssh).to have_key("ssh_port")
    end

    it "should have private_networking set" do
      private_networking = data["defaults"]
      expect(private_networking).to have_key("private_networking")
    end

    it "should have backups_enabled set" do
      backups_enabled = data["defaults"]
      expect(backups_enabled).to have_key("backups_enabled")
    end
  end
  describe "backwards compatible" do
    let(:client_key)       { "foo" }
    let(:api_key)          { "bar" }
    let(:ssh_user)         { "baz" }
    let(:ssh_key_path)     { "~/.ssh/id_rsa2" }
    let(:ssh_port)         { "22" }

    let(:config)                    { config = Tugboat::Configuration.instance }
    let(:config_default_region)     { Tugboat::Configuration::DEFAULT_REGION }
    let(:config_default_image)      { Tugboat::Configuration::DEFAULT_IMAGE }
    let(:config_default_size)       { Tugboat::Configuration::DEFAULT_SIZE }
    let(:config_default_ssh_key)    { Tugboat::Configuration::DEFAULT_SSH_KEY }
    let(:config_default_networking) { Tugboat::Configuration::DEFAULT_PRIVATE_NETWORKING }
    let(:config_default_backups)    { Tugboat::Configuration::DEFAULT_BACKUPS_ENABLED }
    let(:backwards_config) {
      {
                "authentication" => { "client_key" => client_key, "api_key" => api_key },
                "ssh" => { "ssh_user" => ssh_user, "ssh_key_path" => ssh_key_path , "ssh_port" => ssh_port},
      }
    }

    before :each do
      config.instance_variable_set(:@data, backwards_config)
    end

    it "should load a backwards compatible config file" do
      data_file = config.instance_variable_get(:@data)
      expect(data_file).to eql backwards_config
    end

    it "should use default region if not in configuration" do
      region = config.default_region
      expect(region).to eql config_default_region
    end

    it "should use default image if not in configuration" do
      image = config.default_image
      expect(image).to eql config_default_image
    end

    it "should use default size if not in configuration" do
      size = config.default_size
      expect(size).to eql config_default_size
    end

    it "should use default ssh key if not in configuration" do
      ssh_key = config.default_ssh_key
      expect(ssh_key).to eql config_default_ssh_key
    end

    it "should use default private networking option if not in configuration" do
      private_networking = config.default_private_networking
      expect(private_networking).to eql config_default_networking
    end

    it "should use default backups_enabled if not in the configuration" do
      backups_enabled = config.default_backups_enabled
      expect(backups_enabled).to eql config_default_backups
    end

  end
end
