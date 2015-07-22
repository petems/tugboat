require 'spec_helper'

shared_context "spec" do
  # Default configuration and
  let(:config)             { Tugboat::Configuration.instance }
  let(:access_token)       { ENV['DIGITAL_OCEAN_ACCESS_KEY'] }
  let(:ssh_user)           { "baz" }
  let(:ssh_port)           { "33" }
  let(:ssh_key_path)       { "~/.ssh/id_rsa2" }
  let(:droplet_name)       { "foo" }
  let(:droplet_ip)         { "33.33.33.10" }
  let(:droplet_ip_private) { "10.20.30.40" }
  let(:droplet_id)         { 1234 }
  let(:region)             { '3' }
  let(:image)              { '345791'}
  let(:size)               { '67'}
  let(:ssh_key_id)         { '1234' }
  let(:ssh_key_name)       { 'macbook_pro' }
  let(:ssh_public_key)     { 'ssh-dss A123= user@host' }
  let(:private_networking) { 'false'}
  let(:backups_enabled)    { 'false'}
  let(:ocean)              { Barge::Client.new(access_token: access_key) }
  let(:app)                { lambda { |env| } }
  let(:env)                { {} }

  before(:each) do
    $stdout.sync = true
    $stderr.sync = true

    @cli = Tugboat::CLI.new

    # Set a temprary project path and create fake config.
    config.create_config_file(access_token, ssh_key_path, ssh_user, ssh_port, region, image, size, ssh_key_id, private_networking, backups_enabled)
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
