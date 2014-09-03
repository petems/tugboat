require 'spec_helper'

describe Tugboat::Middleware::InjectClient do
  include_context "spec"

  let(:tmp_path)             { project_path + "/tmp/tugboat" }

  before :each do
    config = Tugboat::Configuration.instance
    env["config"] = config
  end

  describe ".call" do

    it "loads the client into the environment" do
      described_class.new(app).call(env)

      env["ocean"].should be_a DigitalOcean::API
    end

    it "creates a client with values from config file" do
      DigitalOcean::API.should_receive(:new).with(hash_including(:client_id=>"foo", :api_key=>"bar"))

      described_class.new(app).call(env)
    end

  end

end
