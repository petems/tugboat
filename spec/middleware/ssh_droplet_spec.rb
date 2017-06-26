require 'spec_helper'

describe Tugboat::Middleware::SSHDroplet do
  include_context 'spec'

  before do
    allow(Kernel).to receive(:exec)
  end

  describe '.call' do
    it 'exec ssh with correct options' do
      expect(Kernel).to receive(:exec).with('ssh',
                                            '-o', 'LogLevel=ERROR',
                                            '-o', 'StrictHostKeyChecking=no',
                                            '-o', 'UserKnownHostsFile=/dev/null',
                                            '-o', 'IdentitiesOnly=yes',
                                            '-i', File.expand_path(ssh_key_path),
                                            '-p', ssh_port,
                                            "#{ssh_user}@#{droplet_ip}")

      env['droplet_ip'] = droplet_ip
      env['config'] = config

      expect { described_class.new(app).call(env) }.to output(/SShing with options: -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=\/dev\/null -o IdentitiesOnly=yes -i #{File.expand_path(ssh_key_path)} -p 33 baz@33.33.33.10/).to_stdout
    end

    it 'exec ssh with IdentitiesOnly=no if no ssh_key_path in config' do
      expect(Kernel).to receive(:exec).with('ssh',
                                            '-o', 'LogLevel=ERROR',
                                            '-o', 'StrictHostKeyChecking=no',
                                            '-o', 'UserKnownHostsFile=/dev/null',
                                            '-o', 'IdentitiesOnly=no',
                                            '-p', ssh_port,
                                            "#{ssh_user}@#{droplet_ip}")

      env['droplet_ip'] = droplet_ip

      config.data['ssh']['ssh_key_path'] = nil

      env['config'] = config

      expect { described_class.new(app).call(env) }.to output(/SShing with options: -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=\/dev\/null -o IdentitiesOnly=no -p 33 baz@33.33.33.10/).to_stdout
    end

    it 'executes ssh with custom options' do
      expect(Kernel).to receive(:exec).with('ssh',
                                            '-o', 'LogLevel=ERROR',
                                            '-o', 'StrictHostKeyChecking=no',
                                            '-o', 'UserKnownHostsFile=/dev/null',
                                            '-o', 'IdentitiesOnly=yes',
                                            '-i', File.expand_path(ssh_key_path),
                                            '-p', ssh_port,
                                            '-e',
                                            '-q',
                                            '-X',
                                            "#{ssh_user}@#{droplet_ip}",
                                            'echo hello')

      env['droplet_ip'] = droplet_ip
      env['droplet_ip_private'] = droplet_ip_private
      env['config'] = config
      env['user_droplet_ssh_command'] = 'echo hello'
      env['user_droplet_use_public_ip'] = true
      env['user_droplet_ssh_opts'] = '-e -q -X'

      expect { described_class.new(app).call(env) }.to output(/SShing with options: -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=\/dev\/null -o IdentitiesOnly=yes -i #{File.expand_path(ssh_key_path)} -p 33 -e -q -X baz@33.33.33.10 echo hello/).to_stdout
    end

    it 'executes ssh with private IP if option chosen' do
      expect(Kernel).to receive(:exec).with('ssh',
                                            '-o', 'LogLevel=ERROR',
                                            '-o', 'StrictHostKeyChecking=no',
                                            '-o', 'UserKnownHostsFile=/dev/null',
                                            '-o', 'IdentitiesOnly=yes',
                                            '-i', File.expand_path(ssh_key_path),
                                            '-p', ssh_port,
                                            '-e',
                                            '-q',
                                            '-X',
                                            "#{ssh_user}@#{droplet_ip_private}",
                                            'echo hello')

      env['droplet_ip'] = droplet_ip
      env['droplet_ip_private'] = droplet_ip_private
      env['config'] = config
      env['user_droplet_ssh_command'] = 'echo hello'
      env['user_droplet_use_private_ip'] = true
      env['user_droplet_ssh_opts'] = '-e -q -X'

      expect { described_class.new(app).call(env) }.to output(%r{You did! Using private IP for ssh...}).to_stdout
    end

    it 'errors if private IP option given but no Private IP on Droplet' do
      env['droplet_ip'] = droplet_ip
      env['config'] = config
      env['user_droplet_ssh_command'] = 'echo hello'
      env['user_droplet_use_private_ip'] = true
      env['user_droplet_ssh_opts'] = '-e -q -X'

      expect { described_class.new(app).call(env) }.to raise_error(SystemExit).and output(%r{You asked to ssh to the private IP, but no Private IP found}).to_stdout

      expected_string = <<-eos
Executing SSH on Droplet ...
You asked to ssh to the private IP, but no Private IP found!
      eos
    end
  end
end
