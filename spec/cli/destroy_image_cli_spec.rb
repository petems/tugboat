require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "destroy image" do
    it "destroys an image with a fuzzy name" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.destroy_image("NLP Final")

      expect($stdout.string).to eq <<-eos
Image fuzzy name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 478 (NLP Final)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end

    it "destroys an image with an id" do
      stub_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      stub_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:id => 478)
      @cli.destroy_image

      expect($stdout.string).to eq <<-eos
Image id provided. Finding Image...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 478 (NLP Final)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images/478?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "destroys an image with a name" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      expect($stdin).to receive(:gets).and_return("y")

      @cli.options = @cli.options.merge(:name => "NLP Final")
      @cli.destroy_image

      expect($stdout.string).to eq <<-eos
Image name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nWarning! Potentially destructive action. Please confirm [y/n]: Queuing destroy image for 478 (NLP Final)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end


    it "destroys an image with confirm flag set" do
      stub_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_images"))

      stub_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}").
           to_return(:status => 200, :body => fixture("show_image"))

      @cli.options = @cli.options.merge(:name => "NLP Final")
      @cli.options = @cli.options.merge(:confirm => true)
      @cli.destroy_image("NLP Final")

      expect($stdout.string).to eq <<-eos
Image name provided. Finding image ID...done\e[0m, 478 (NLP Final)\nQueuing destroy image for 478 (NLP Final)...done
      eos

      expect(a_request(:get, "https://api.digitalocean.com/images?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
      expect(a_request(:get, "https://api.digitalocean.com/images/478/destroy?api_key=#{api_key}&client_id=#{client_key}")).to have_been_made
    end
  end

end
