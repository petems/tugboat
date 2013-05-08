require 'spec_helper'

describe Tugboat::Middleware::CheckDropletInactive do
  include_context "spec"

  describe ".call" do
    it "raises an error when droplet is active" do

      env["droplet_status"] = "active"

      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
    end
  end

end
