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
    let(:client_key)       { "foo" }
    let(:api_key)          { "bar" }
    let(:ssh_user)         { "baz" }
    let(:ssh_key_path)     { "~/.ssh/id_rsa2" }
    let(:ssh_key_path)     { "~/.ssh/id_rsa2.pub" }
    let(:ssh_port)         { "22" }
    let(:region)           { "2" }
    let(:image)            { "345791" }
    let(:size)             { "66" }
    let(:ssh_key_id)       { '1234' }

    let(:config)           { config = Tugboat::Configuration.instance }

    before :each do
      # Create a temporary file
      config.create_config_file(client_key, api_key, ssh_key_path, ssh_user, ssh_port, region, image, size, ssh_key_id)
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

      it "should have a client key" do
        auth = data["authentication"]
        expect(auth).to have_key("client_key")
      end

      it "should have an api key" do
        auth = data["authentication"]
        expect(auth).to have_key("api_key")
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
  end
end
