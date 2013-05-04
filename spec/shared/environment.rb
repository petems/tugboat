require 'spec_helper'

shared_context "spec" do
  # Default configuration and
  let(:config)           { Tugboat::Configuration.instance }
  let(:client_key)       { "foo" }
  let(:api_key)          { "bar" }
  let(:ssh_user)         { "baz" }
  let(:ssh_port)         { "22" }
  let(:ssh_key_path)     { "~/.ssh/id_rsa2" }
  let(:droplet_name)     { "foo" }
  let(:droplet_ip)       { "33.33.33.10" }
  let(:droplet_id)       { 1234 }
  let(:ocean)            { DigitalOcean::API.new :client_id => client_key, :api_key =>api_key }

  before(:each) do
    $stdout.sync = true
    $stderr.sync = true


    # Set a temprary project path and create fake config.
    config.create_config_file(client_key, api_key, ssh_key_path, ssh_user, ssh_port)
    config.reload!

    # Keep track of the old stderr / out
    @orig_stderr = $stderr
    @orig_stdout = $stdout

    # Make them strings so we can manipulate and compare.
    $stderr = StringIO.new
    $stdout = StringIO.new
  end

  after(:each) do
    # Reassign the stderr / out so rspec can have it back.
    $stderr = @orig_stderr
    $stdout = @orig_stdout
  end

  after(:each) do
    # Delete the temporary configuration file if it exists.
    File.delete(project_path + "/tmp/tugboat") if File.exist?(project_path + "/tmp/tugboat")
  end

end
