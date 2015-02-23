require 'spec_helper'

describe Tugboat::Middleware::CheckCredentials do
  include_context "spec"

  describe ".call" do
    it "raises SystemExit with no configuration" do
      stub_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.1'}).
         to_return(:headers => {'Content-Type' => 'application/json'}, :status => 200, :body => "<html>You are being redirected...</html>")

      # Inject the client.
      env["barge"] = ocean

      expect {described_class.new(app).call(env) }.to raise_error(SystemExit)
      expect(a_request(:get, "https://api.digitalocean.com/v2/droplets?per_page=200")).
        to have_been_made
    end
  end

end
