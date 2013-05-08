require 'spec_helper'

describe Tugboat::Middleware::CheckCredentials do
  include_context "spec"

  describe ".call" do
    it "raises SystemExit with no configuration" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
         to_return(:status => 200, :body => "<html>You are being redirected...</html>")

      # Inject the client.
      env["ocean"] = ocean

      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
      expect(a_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}")).
        to have_been_made
    end
  end

end
