require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'create a droplet' do
    it 'with a name, uses defaults from configuration' do
      stub_request(:post, 'https://api.digitalocean.com/v2/droplets').
        with(body: '{"name":"foo","size":"512mb","image":"ubuntu-14-04-x64","region":"nyc2","ssh_keys":["1234"],"private_networking":"false","backups_enabled":"false","ipv6":"false","user_data":null}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('create_droplet'), headers: {})

      expected_string = <<-eos
Queueing creation of droplet '#{droplet_name}'...Droplet created! Droplet ID is 3164494
      eos

      expect { cli.create(droplet_name) }.to output(expected_string).to_stdout
    end

    it 'with args does not use defaults from configuration' do
      stub_request(:post, 'https://api.digitalocean.com/v2/droplets').
        with(body: '{"name":"example.com","size":"1gb","image":"ubuntu-12-04-x64","region":"nyc3","ssh_keys":["foo_bar_key"],"private_networking":"false","backups_enabled":"false","ipv6":"false","user_data":null}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('create_droplet'), headers: {})

      cli.options = cli.options.merge(image: 'ubuntu-12-04-x64', size: '1gb', region: 'nyc3', keys: 'foo_bar_key')

      expected_string = <<-eos
Queueing creation of droplet 'example.com'...Droplet created! Droplet ID is 3164494
      eos

      expect { cli.create('example.com') }.to output(expected_string).to_stdout
    end

    it 'with ip6 enable args' do
      stub_request(:post, 'https://api.digitalocean.com/v2/droplets').
        with(body: '{"name":"example.com","size":"512mb","image":"ubuntu-14-04-x64","region":"nyc2","ssh_keys":["1234"],"private_networking":"false","backups_enabled":"false","ipv6":"true","user_data":null}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('create_droplet'), headers: {})

      cli.options = cli.options.merge(ip6: 'true')

      expected_string = <<-eos
Queueing creation of droplet 'example.com'...Droplet created! Droplet ID is 3164494
      eos

      expect { cli.create('example.com') }.to output(expected_string).to_stdout
    end

    it 'with user data args' do
      stub_request(:post, 'https://api.digitalocean.com/v2/droplets').
        with(body: '{"name":"example.com","size":"512mb","image":"ubuntu-14-04-x64","region":"nyc2","ssh_keys":["1234"],"private_networking":"false","backups_enabled":"false","ipv6":"false","user_data":"#!/bin/bash\\n\\necho \\"Hello world\\""}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('create_droplet'), headers: {})

      cli.options = cli.options.merge(user_data: project_path + '/spec/fixtures/user_data.sh')

      expected_string = <<-eos
Queueing creation of droplet 'example.com'...Droplet created! Droplet ID is 3164494
      eos

      expect { cli.create('example.com') }.to output(expected_string).to_stdout
    end

    it 'fails when user data file does not exist' do
      cli.options = cli.options.merge(user_data: '/foo/bar/baz.sh')

      expected_string = <<-eos
Queueing creation of droplet 'example.com'...Could not find file: /foo/bar/baz.sh, check your user_data setting
      eos

      expect { expect { cli.create('example.com') }.to raise_error(SystemExit) }.to output(expected_string).to_stdout
    end

    context "doesn't create a droplet when mistyping help command" do
      ['help', '--help', '-h'].each do |help_attempt|
        it "tugboat create #{help_attempt}" do
          expected_string = <<-eos
Usage:
  rspec create NAME

Options:
  -s, [--size=SIZE]            # The size slug of the droplet
  -i, [--image=IMAGE]          # The image slug of the droplet
  -r, [--region=REGION]        # The region slug of the droplet
  -k, [--keys=KEYS]            # A comma separated list of SSH key ids to add to the droplet
  -p, [--private-networking]   # Enable private networking on the droplet
  -l, [--ip6]                  # Enable IP6 on the droplet
  -u, [--user-data=USER_DATA]  # Location of a file to read and use as user data
  -b, [--backups-enabled]      # Enable backups on the droplet
  -q, [--quiet]               \x20

Create a droplet.
eos

          expect { cli.create(help_attempt) }.to output(expected_string).to_stdout
        end
      end
    end

    it 'does not clobber named droplets that contain the word help' do
      stub_request(:post, 'https://api.digitalocean.com/v2/droplets').
        with(body: '{"name":"somethingblahblah--help","size":"512mb","image":"ubuntu-14-04-x64","region":"nyc2","ssh_keys":["1234"],"private_networking":"false","backups_enabled":"false","ipv6":"false","user_data":null}',
             headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('create_droplet'), headers: {})

      expected_string = <<-eos
Queueing creation of droplet 'somethingblahblah--help'...Droplet created! Droplet ID is 3164494
      eos

      expect { cli.create('somethingblahblah--help') }.to output(expected_string).to_stdout
    end
  end
end
