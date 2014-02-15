require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "rebuild" do
    it "rebuilds a droplet with a fuzzy name based on an image with a fuzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"), :headers => {})
            
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with an id based on an image with a fuzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))
          
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => droplet_id)
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)\nImage fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with a name based on an image with a fuzy name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))
          
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => droplet_name)
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with a fuzzy name based on an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"), :headers => {})
            
      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:image_id => 478)
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage id provided. Finding Image...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with an id based on an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))
            
      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => droplet_id, :image_id => 478)
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)\nImage id provided. Finding Image...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with a name based on an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))
            
      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => droplet_name, :image_id => 478)
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage id provided. Finding Image...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with a fuzzy name based on an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"), :headers => {})
            
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:image_name => "NLP Final")
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with an id based on an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets/#{droplet_id}?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplet"))
            
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => droplet_id, :image_name => "NLP Final")
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet id provided. Finding Droplet...done\e[0m, 100823 (foo)\nImage name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with a name based on an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"))
            
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      $stdin.should_receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => droplet_name, :image_name => "NLP Final")
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end

    it "rebuilds a droplet with confirm flag set" do
      stub_request(:get, "https://api.digitalocean.com/droplets?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_droplets"), :headers => {})
            
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"), :headers => {})

      stub_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478").
           to_return(:status => 200, :body => '{ "status": "OK",  "event_id": 7504 }', :headers => {})

      @cli.options = @cli.options.merge(:confirm => "no")
      @cli.rebuild("foo", "NLP Final")

      expect($stdout.string).to eq <<-eos
Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 100823 (foo)\nImage fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nQueuing rebuild for droplet 100823 (foo) with image 478 (NLP Final)...done
      eos
      expect(a_request(:post, "https://api.digitalocean.com/droplets/100823/rebuild?api_key=#{api_key}&client_id=#{client_key}&image_id=478")).to have_been_made
    end
  end

end
