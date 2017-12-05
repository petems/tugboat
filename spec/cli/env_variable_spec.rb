require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'DO_API_TOKEN=foobar' do
    it 'verifies with the ENV variable DO_API_TOKEN' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer env_variable', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return('env_variable')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expected_string = "Authentication with DigitalOcean was successful.\n"
      expect { cli.verify }.to output(expected_string).to_stdout
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made
    end

    it 'does not use ENV variable DO_API_TOKEN if empty' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return('')
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return(nil)

      expected_string = "Authentication with DigitalOcean was successful.\n"
      expect { cli.verify }.to output(expected_string).to_stdout
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made
    end
  end

  describe 'THOR_SHELL=Basic' do
    it 'removes colour from the string if THOR_SHELL is set to basic' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return('Basic')

      expected_string =   <<-eos
Authentication with DigitalOcean was successful.
      eos

      not_expected_string =   <<-eos
\e[32mAuthentication with DigitalOcean was successful.\e[0m
      eos

      expectation = expect { cli.verify }
      expectation.to output(expected_string).to_stdout
      expectation.to_not output(not_expected_string).to_stdout
    end

    it 'leaves colour from the string if THOR_SHELL is not set to basic' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      allow(ENV).to receive(:[]).with('DEBUG').and_return(nil)
      allow(ENV).to receive(:[]).with('http_proxy').and_return(nil)
      allow(ENV).to receive(:[]).with('DO_API_TOKEN').and_return(nil)
      allow(ENV).to receive(:[]).with('HOME').and_return('/tmp/fake_home')
      allow(ENV).to receive(:[]).with('THOR_SHELL').and_return('Color')

      expected_string =   <<-eos
\e[32mAuthentication with DigitalOcean was successful.\e[0m
      eos

      expected_string = "Authentication with DigitalOcean was successful.\n"
      expect { cli.verify }.to output(expected_string).to_stdout
    end
  end
end
