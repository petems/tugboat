require 'spec_helper'

describe Tugboat::Middleware::InjectConfiguration do
  include_context "middleware"

#   let(:klass)      { described_class.new }

  describe ".call" do
    it "loads the configuration into the environment" do
      data = {}
      klass = described_class.new(app)
      klass.call(data)
      data["config"].should be
    end
  end

end
