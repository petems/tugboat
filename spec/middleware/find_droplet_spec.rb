require 'spec_helper'

describe Tugboat::Middleware::FindDroplet do
  include_context "spec"

  describe ".call" do
    it "raises SystemExit with no droplet data" do
      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)

      expect($stdout.string).to include 'Tugboat attempted to find a droplet with no arguments'
      expect($stdout.string).to include 'For more help run: '
      expect($stdout.string).to include 'Try running `tugboat '
    end
  end

end
