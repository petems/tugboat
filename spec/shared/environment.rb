
shared_context "middleware" do
  # Default configuration and
  let(:config)           { Tugboat::Configuration.instance }
  let(:client_key)       { "foo" }
  let(:api_key)          { "bar" }
  let(:ssh_user)         { "baz" }
  let(:ssh_key_path)     { "~/.ssh/id_rsa2" }
  let(:droplet_name)     { "foo" }
  let(:droplet_id)       { 1234 }


  before(:each) do
    $stdout.sync = true
    $stderr.sync = true

    # Set a temprary project path and create fake config.
    config.path = project_path + "/tmp/tugboat"
    config.create_config_file(client_key, api_key, ssh_user, ssh_key_path)

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

end
