require 'spec_helper'

describe Tugboat::Middleware::CheckConfiguration do
  include_context "spec"

  describe ".call" do
    it "raises SystemExit with no configuration" do

      # Delete the temp configuration file.
      File.delete(project_path + "/tmp/tugboat")

      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
    end
  end

end
