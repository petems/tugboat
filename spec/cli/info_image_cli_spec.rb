require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'info_image' do
    it 'shows an image with a fuzzy name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      stub_request(:get, 'https://api.digitalocean.com/v2/images/12789325?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_coreos_image'))

      expected_string = <<-eos
Image fuzzy name provided. Finding image ID...done\e[0m, 12789325 (745.1.0 (alpha))

Name:             745.1.0 (alpha)
ID:               12789325
Distribution:     CoreOS
Min Disk Size:    20GB
Regions:          nyc1,sfo1,nyc2,ams2,sgp1,lon1,nyc3,ams3,fra1
      eos

      expect { cli.info_image('745.1.0 (alpha)') }.to output(expected_string).to_stdout
    end

    it 'shows an image with an id' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      stub_request(:get, 'https://api.digitalocean.com/v2/images/12438838?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_redmine_image'))

      expected_string = <<-eos
Image id provided. Finding Image...done\e[0m, 12438838 (Redmine on 14.04)

Name:             Redmine on 14.04
ID:               12438838
Distribution:     Ubuntu
Min Disk Size:    20GB
Regions:          nyc1,ams1,sfo1,nyc2,ams2,sgp1,lon1,nyc3,ams3,fra1
      eos

      cli.options = cli.options.merge(id: 12_438_838)
      expect { cli.info_image }.to output(expected_string).to_stdout
    end

    it 'shows an image with a name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      stub_request(:get, 'https://api.digitalocean.com/v2/images/12438838?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_redmine_image'))

      expected_string = <<-eos
Image name provided. Finding Image...done\e[0m, 12438838 (Redmine on 14.04)

Name:             Redmine on 14.04
ID:               12438838
Distribution:     Ubuntu
Min Disk Size:    20GB
Regions:          nyc1,ams1,sfo1,nyc2,ams2,sgp1,lon1,nyc3,ams3,fra1
      eos

      cli.options = cli.options.merge(name: 'Redmine on 14.04')
      expect { cli.info_image }.to output(expected_string).to_stdout
    end

    it 'errors if no image with matching id is found' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      stub_request(:get, 'https://api.digitalocean.com/v2/images/123?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 404, body: fixture('not_found'), headers: {})

      expected_string = <<-eos
Image id provided. Finding Image...Failed to find Image: The resource you were accessing could not be found.
      eos

      cli.options = cli.options.merge(id: '123')
      expect { cli.info_image }.to raise_error(SystemExit).and output(expected_string).to_stdout
    end

    it 'errors if no image with matching name is found' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      cli.options = cli.options.merge(name: 'foobarbaz')

      expected_string = <<-eos
Image name provided. Finding Image...error
Unable to find an image named 'foobarbaz'.
      eos

      expect { cli.info_image }.to raise_error(SystemExit).and output(expected_string).to_stdout
    end

    it 'errors if no image with matching fuzzy name is found' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      expected_string = <<-eos
Image fuzzy name provided. Finding image ID...error
Unable to find an image named 'foobarbaz'.
      eos

      expect { cli.info_image('foobarbaz') }.to raise_error(SystemExit).and output(expected_string).to_stdout
    end

    it 'allows choice of multiple images' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(headers: { 'Content-Type' => 'application/json' }, status: 200, body: fixture('show_images'))

      stub_request(:get, 'https://api.digitalocean.com/v2/images/9801951?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('ubuntu_image_9801951'), headers: {})

      expect($stdin).to receive(:gets).and_return('0')

      expected_string = <<-eos
Image fuzzy name provided. Finding image ID...Multiple images found.

0) 14.10 x32 (9801951)
1) 14.10 x64 (9801954)
2) 12.04.5 x64 (10321756)
3) 12.04.5 x32 (10321777)
4) 15.04 x64 (12658446)
5) 15.04 x32 (12660649)
6) 14.04 x32 (12790298)
7) 14.04 x64 (12790328)

Please choose a image: ["0", "1", "2", "3", "4", "5", "6", "7"]\x20
Name:             14.10 x32
ID:               9801951
Distribution:     Ubuntu
Min Disk Size:    20GB
Regions:          nyc1,ams1,sfo1,nyc2,ams2,sgp1,lon1,nyc3,ams3,fra1
      eos

      expect { cli.info_image('ubun') }.to output(expected_string).to_stdout
    end
  end
end
