require 'spec_helper'

describe Tugboat::CLI do
  include_context 'spec'

  describe 'destroy image' do
    it 'destroys an image with a fuzzy name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_images_global'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/images/6376601').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      expected_string = <<-eos
Image fuzzy name provided. Finding image ID...done\e[0m, 6376601 (My application image)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 6376601 (My application image)...Image deletion successful!
      eos

      expect { cli.destroy_image('My application image') }.to output(expected_string).to_stdout
    end

    it 'destroys an image with an id' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images/6376601?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_image'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/images/6376601').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      cli.options = cli.options.merge(id: 6_376_601)

      expected_string = <<-eos
Image id provided. Finding Image...done\e[0m, 6376601 (My application image)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 6376601 (My application image)...Image deletion successful!
      eos

      expect { cli.destroy_image }.to output(expected_string).to_stdout
    end

    it 'destroys an image with a name' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_images_global'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/images/6376601').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      expect($stdin).to receive(:gets).and_return('y')

      expected_string = "Image name provided. Finding Image...done\e[0m, 6376601 (My application image)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 6376601 (My application image)...Image deletion successful!\n"

      cli.options = cli.options.merge(name: 'My application image')
      expect { cli.destroy_image }.to output(expected_string).to_stdout
    end

    it 'destroys an image with confirm flag set' do
      stub_request(:get, 'https://api.digitalocean.com/v2/images?per_page=200').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 200, body: fixture('show_images_global'), headers: {})

      stub_request(:delete, 'https://api.digitalocean.com/v2/images/6376601').
        with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization' => 'Bearer foo', 'Content-Type' => 'application/json', 'User-Agent' => 'Faraday v0.9.2' }).
        to_return(status: 204, body: '', headers: {})

      cli.options = cli.options.merge(name: 'My application image')
      cli.options = cli.options.merge(confirm: true)

      expected_string = <<-eos
Image name provided. Finding Image...done\e[0m, 6376601 (My application image)\nQueuing destroy image for 6376601 (My application image)...Image deletion successful!
      eos

      expect { cli.destroy_image('NLP Final') }.to output(expected_string).to_stdout
    end
  end
end
