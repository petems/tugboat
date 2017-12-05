require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'snapshots' do
    it 'shows a list when snapshots exist' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, "https://api.digitalocean.com/v2/snapshots?page=1&per_page=20").
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(status: 200, body: fixture('show_snapshots'), headers: {})

      expected_string =   <<-eos
5.10 x64 (id: 6372321, resource_type: droplet, created_at: 2014-09-26T16:40:18Z)
      eos

      expect { cli.snapshots }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.once
      expect(a_request(:get, 'https://api.digitalocean.com/v2/snapshots?page=1&per_page=20')).to have_been_made.once
    end

    it 'shows a message when no snapshots exist' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, "https://api.digitalocean.com/v2/snapshots?page=1&per_page=20").
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(status: 200, body: fixture('show_snapshots_empty'), headers: {})

      expected_string =   <<-eos
You don't appear to have any snapshots.
      eos

      expect { cli.snapshots }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.once
      expect(a_request(:get, 'https://api.digitalocean.com/v2/snapshots?page=1&per_page=20')).to have_been_made.once
    end

  end
end
