require 'spec_helper'

describe Tugboat::Middleware::SSHDroplet do
  include_context "spec"

  let(:app) { lambda { |env| } }
  let(:env) { {} }

  before do
    Kernel.stub!(:exec)
  end

  describe ".call" do

    it "exec ssh with correct options" do
      Kernel.should_receive(:exec).with("ssh",
                        "-o", "IdentitiesOnly=yes",
                        "-o", "LogLevel=ERROR",
                        "-o", "StrictHostKeyChecking=no",
                        "-o", "UserKnownHostsFile=/dev/null",
                        "-i", ssh_key_path,
                        "-p", ssh_port,
                        "#{ssh_user}@#{droplet_ip}")

      env["droplet_ip"] = droplet_ip
      env["config"] = config

      described_class.new(app).call(env)
    end

  end

end
