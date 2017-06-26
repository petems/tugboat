require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'sizes' do
    it 'shows a list' do
      stub_request(:get, 'https://api.digitalocean.com/v2/sizes?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_sizes'))

      cli_sizes_output = <<-eos
Sizes:
Disk: 20GB, Memory: 512MB (slug: 512mb)
Disk: 30GB, Memory: 1024MB (slug: 1gb)
Disk: 40GB, Memory: 2048MB (slug: 2gb)
Disk: 60GB, Memory: 4096MB (slug: 4gb)
Disk: 80GB, Memory: 8192MB (slug: 8gb)
Disk: 160GB, Memory: 16384MB (slug: 16gb)
Disk: 320GB, Memory: 32768MB (slug: 32gb)
Disk: 480GB, Memory: 49152MB (slug: 48gb)
Disk: 640GB, Memory: 65536MB (slug: 64gb)
      eos

      expect { cli.sizes }.to output(cli_sizes_output).to_stdout
    end
  end
end
