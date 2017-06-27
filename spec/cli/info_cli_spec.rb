require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'info' do
    it 'shows an error if response is not successful' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 404, body: fixture('not_found'), headers: {})

      cli.options = cli.options.merge(id: 6_918_990)

      expect { cli.info }.to raise_error(SystemExit)

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...Failed to find Droplet: The resource you were accessing could not be found.
      eos

      expect(a_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200')).to have_been_made
    end

    it 'shows a droplet with a fuzzy name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      cli.info('example.com')

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)

Name:             example.com
ID:               6918990
Status:           \e[32mactive\e[0m
IP4:              104.131.186.241
IP6:              2604:A880:0800:0010:0000:0000:031D:2001
Region:           New York 3 - nyc3
Image:            6918990 - ubuntu-14-04-x64
Size:             512MB
Backups Active:   false
      eos
    end

    it 'shows a droplet made from a user image' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet_user_image'), headers: {})

      cli.options = cli.options.merge(id: 6_918_990)
      cli.info

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)

Name:             example.com
ID:               6918990
Status:           \e[32mactive\e[0m
IP4:              104.131.186.241
IP6:              2604:A880:0800:0010:0000:0000:031D:2001
Region:           New York 3 - nyc3
Image:            36646276 - Super Cool Custom Image
Size:             512MB
Backups Active:   false
      eos
    end

    it 'shows a droplet with an id' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      cli.options = cli.options.merge(id: 6_918_990)
      cli.info

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)

Name:             example.com
ID:               6918990
Status:           \e[32mactive\e[0m
IP4:              104.131.186.241
IP6:              2604:A880:0800:0010:0000:0000:031D:2001
Region:           New York 3 - nyc3
Image:            6918990 - ubuntu-14-04-x64
Size:             512MB
Backups Active:   false
      eos
    end

    it 'shows a droplet with a name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      cli.options = cli.options.merge(name: 'example.com')
      cli.info

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)

Name:             example.com
ID:               6918990
Status:           \e[32mactive\e[0m
IP4:              104.131.186.241
IP6:              2604:A880:0800:0010:0000:0000:031D:2001
Region:           New York 3 - nyc3
Image:            6918990 - ubuntu-14-04-x64
Size:             512MB
Backups Active:   false
      eos
    end

    it 'allows choice of multiple droplets' do
      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplets'), headers: {})

      stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_droplet'), headers: {})

      expect($stdin).to receive(:gets).and_return('0')

      cli.info('examp')

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...Multiple droplets found.

0) example.com (6918990)
1) example2.com (3164956)
2) example3.com (3164444)

Please choose a droplet: ["0", "1", "2"]\x20
Name:             example.com
ID:               6918990
Status:           \e[32mactive\e[0m
IP4:              104.131.186.241
IP6:              2604:A880:0800:0010:0000:0000:031D:2001
Region:           New York 3 - nyc3
Image:            6918990 - ubuntu-14-04-x64
Size:             512MB
Backups Active:   false
      eos
    end
  end

  it 'shows a droplet with an id under porcelain mode' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(id: '6918990', porcelain: true)
    cli.info

    expect($stdout.string).to eq <<-eos
name example.com
id 6918990
status active
ip4 104.131.186.241
ip6 2604:A880:0800:0010:0000:0000:031D:2001
region nyc3
image 6918990
size 512mb
backups_active false
      eos
  end

  it 'shows a droplet with a name under porcelain mode' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(name: 'example.com', porcelain: true)
    cli.info

    expect($stdout.string).to eq <<-eos
name example.com
id 6918990
status active
ip4 104.131.186.241
ip6 2604:A880:0800:0010:0000:0000:031D:2001
region nyc3
image 6918990
size 512mb
backups_active false
      eos
  end

  it 'shows a droplet attribute with an id' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(id: '6918990', attribute: 'ip4')
    cli.info

    expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 6918990 (example.com)
104.131.186.241
    eos
  end

  it 'shows a droplet attribute with a name' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(name: 'example.com', attribute: 'ip4')
    cli.info

    expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
104.131.186.241
    eos
  end

  it 'gives error if invalid attribute given' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(id: 6_918_990, porcelain: true, attribute: 'foo')
    expect { cli.info }.to raise_error(SystemExit)

    expect($stdout.string).to eq <<-eos
Invalid attribute "foo"
Provide one of the following:
    name
    id
    status
    ip4
    ip6
    private_ip
    region
    image
    size
    backups_active
      eos
  end

  it 'shows a droplet attribute with an id under porcelain mode' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(id: '6918990', porcelain: true, attribute: 'ip4')
    cli.info

    expect($stdout.string).to eq <<-eos
104.131.186.241
      eos
  end

  it 'shows a droplet attribute with a name under porcelain mode' do
    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=1').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets?page=1&per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplets'), headers: {})

    stub_request(:get, 'https://api.digitalocean.com/v2/droplets/6918990?per_page=200').
      with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
      to_return(status: 200, body: fixture('show_droplet'), headers: {})

    cli.options = cli.options.merge(name: 'example.com', porcelain: true, attribute: 'ip4')
    cli.info

    expect($stdout.string).to eq <<-eos
104.131.186.241
    eos
  end
end
