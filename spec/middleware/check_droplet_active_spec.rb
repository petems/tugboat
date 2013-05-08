require 'spec_helper'

describe Tugboat::Middleware::CheckDropletActive do
  include_context "spec"

  describe ".call" do
    it "raises an error when droplet is not active" do

      env["droplet_status"] = "off"

      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
    end
  end

end
