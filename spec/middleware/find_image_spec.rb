require 'spec_helper'

describe Tugboat::Middleware::FindImage do
  include_context "spec"

  describe ".call" do
    it "raises SystemExit with no image data" do
      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
    end
  end

end
