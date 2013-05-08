require 'spec_helper'

describe Tugboat::Middleware::InjectConfiguration do
  include_context "spec"

  describe ".call" do

    it "loads the configuration into the environment" do
      described_class.new(app).call(env)

      env["config"].should == config
    end

  end

end
