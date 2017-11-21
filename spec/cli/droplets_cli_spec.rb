require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'droplets' do
    it 'shows a list when droplets exist' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: { 'Content-Type' => 'application/json' })
      
      expected_string =   <<-eos
example.com (ip: 104.236.32.182, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 6918990)
example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 3164956)
example3.com (ip: 104.236.32.173, status: \e[31moff\e[0m, region: nyc3, size: 512mb, id: 3164444)
      eos

      expect { cli.droplets }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.twice
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20')).to have_been_made
    end

    it 'shows a private IP if droplet in list has private IP' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets_private_ip'), headers: { 'Content-Type' => 'application/json' })

      expected_string =   <<-eos
exampleprivate.com (ip: 104.236.32.182, private_ip: 10.131.99.89, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 6918990)
example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 3164956)
example3.com (ip: 104.236.32.173, status: \e[31moff\e[0m, region: nyc3, size: 512mb, id: 3164444)
      eos

      expect { cli.droplets }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.twice
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20')).to have_been_made
    end

    it 'returns an error message when no droplets exist' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets_empty'), headers: { 'Content-Type' => 'application/json' })

      expected_string =   <<-eos
You don't appear to have any droplets.
Try creating one with \e[32m`tugboat create`\e[0m
      eos

      expect { cli.droplets }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.twice
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20')).to have_been_made
    end

    it 'shows no output when --quiet is set' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: { 'Content-Type' => 'application/json' })

      cli.options = cli.options.merge(quiet: true)
      expect { cli.droplets }.not_to output.to_stderr

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.twice
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20')).to have_been_made
    end

    it 'includes urls when --include-urls is set' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: { 'Content-Type' => 'application/json' })

      cli.options = cli.options.merge('include_urls' => true)

      expected_string = <<-eos
example.com (ip: 104.236.32.182, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 6918990, url: 'https://cloud.digitalocean.com/droplets/6918990')
example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 3164956, url: 'https://cloud.digitalocean.com/droplets/3164956')
example3.com (ip: 104.236.32.173, status: \e[31moff\e[0m, region: nyc3, size: 512mb, id: 3164444, url: 'https://cloud.digitalocean.com/droplets/3164444')
      eos

      expect { cli.droplets }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.twice
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=20')).to have_been_made
    end

    it 'allows specifying per_page' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=3').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets_paginated_first'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=2&per_page=3').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets_paginated_last'), headers: { 'Content-Type' => 'application/json' })

      cli.options = cli.options.merge('per_page' => '3')

      expected_string = <<-eos
page1example.com (ip: 104.236.32.182, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 6918990, url: 'https://cloud.digitalocean.com/droplets/6918990')
page1example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 3164956, url: 'https://cloud.digitalocean.com/droplets/3164956')
page1example3.com (ip: 104.236.32.173, status: \e[31moff\e[0m, region: nyc3, size: 512mb, id: 3164444, url: 'https://cloud.digitalocean.com/droplets/3164444')
page2example.com (ip: 104.236.32.182, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 6918990, url: 'https://cloud.digitalocean.com/droplets/6918990')
page2example2.com (ip: 104.236.32.172, status: \e[32mactive\e[0m, region: nyc3, size: 512mb, id: 3164956, url: 'https://cloud.digitalocean.com/droplets/3164956')
page2example3.com (ip: 104.236.32.173, status: \e[31moff\e[0m, region: nyc3, size: 512mb, id: 3164444, url: 'https://cloud.digitalocean.com/droplets/3164444')
      eos

      expect { cli.droplets }.to output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=3')).to have_been_made
      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=2&per_page=3')).to have_been_made
    end

    it 'shows error on failure in initial stage' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'text/html' }, status: 401, body: fixture('401'))

      expected_string = <<-eos
Failed to connect to DigitalOcean. Reason given from API:
401: {
  \"id\": \"unauthorized\",
  \"message\": \"Unable to authenticate you.\"
}
      eos

      expect { cli.droplets }.to raise_error(SystemExit).and output(expected_string).to_stdout

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1')).to have_been_made.once
    end

  end
end
