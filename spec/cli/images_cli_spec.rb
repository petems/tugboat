require 'spec_helper'

describe Tugboat::CLI do
  include_context "spec"

  describe "images" do
    it "shows all images by default" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200&private=true").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images_global'), :headers => {})

      @cli.images

      expect($stdout.string).to eq <<-eos
Showing both private and public images
Private Images:
My application image (id: 6376601, distro: Ubuntu)

Public Images:
745.1.0 (alpha) (slug: coreos-alpha, id: 12789325, distro: CoreOS)
723.3.0 (beta) (slug: coreos-beta, id: 12789350, distro: CoreOS)
717.3.0 (stable) (slug: coreos-stable, id: 12789351, distro: CoreOS)
5.10 x64 (slug: centos-5-8-x64, id: 6372321, distro: CentOS)
5.10 x32 (slug: centos-5-8-x32, id: 6372425, distro: CentOS)
6.0 x64 (slug: debian-6-0-x64, id: 6372581, distro: Debian)
6.0 x32 (slug: debian-6-0-x32, id: 6372662, distro: Debian)
21 x64 (slug: fedora-21-x64, id: 9640922, distro: Fedora)
14.10 x32 (slug: ubuntu-14-10-x32, id: 9801951, distro: Ubuntu)
14.10 x64 (slug: ubuntu-14-10-x64, id: 9801954, distro: Ubuntu)
10.1 (slug: freebsd-10-1-x64, id: 10144573, distro: FreeBSD)
12.04.5 x64 (slug: ubuntu-12-04-x64, id: 10321756, distro: Ubuntu)
12.04.5 x32 (slug: ubuntu-12-04-x32, id: 10321777, distro: Ubuntu)
7.0 x64 (slug: debian-7-0-x64, id: 10322059, distro: Debian)
7.0 x32 (slug: debian-7-0-x32, id: 10322378, distro: Debian)
7 x64 (slug: centos-7-0-x64, id: 10322623, distro: CentOS)
6.5 x32 (slug: centos-6-5-x32, id: 11523060, distro: CentOS)
6.5 x64 (slug: centos-6-5-x64, id: 11523085, distro: CentOS)
22 x64 (slug: fedora-22-x64, id: 12065782, distro: Fedora)
15.04 x64 (slug: ubuntu-15-04-x64, id: 12658446, distro: Ubuntu)
15.04 x32 (slug: ubuntu-15-04-x32, id: 12660649, distro: Ubuntu)
8.1 x64 (slug: debian-8-x64, id: 12778278, distro: Debian)
8.1 x32 (slug: debian-8-x32, id: 12778337, distro: Debian)
14.04 x32 (slug: ubuntu-14-04-x32, id: 12790298, distro: Ubuntu)
14.04 x64 (slug: ubuntu-14-04-x64, id: 12790328, distro: Ubuntu)
FreeBSD AMP on 10.1 (slug: freebsd-amp, id: 10163059, distro: FreeBSD)
Mumble Server (murmur) on 14.04 (slug: mumble, id: 11132249, distro: Ubuntu)
LAMP on 14.04 (slug: lamp, id: 11146541, distro: Ubuntu)
LEMP on 14.04 (slug: lemp, id: 11146558, distro: Ubuntu)
MEAN on 14.04 (slug: mean, id: 11146864, distro: Ubuntu)
Joomla! 3.4.1 on 14.04 (slug: joomla, id: 11163798, distro: Ubuntu)
Drone on 14.04 (slug: drone, id: 11774848, distro: Ubuntu)
Magento 1.9.1.1 on 14.04 (slug: magento, id: 11876697, distro: Ubuntu)
Ghost 0.6.4 on 14.04 (slug: ghost, id: 12035275, distro: Ubuntu)
Ruby on Rails on 14.04 (Postgres, Nginx, Unicorn) (slug: ruby-on-rails, id: 12035706, distro: Ubuntu)
ownCloud 8.0.4 on 14.04 (slug: owncloud, id: 12333784, distro: Ubuntu)
Drupal 7.38 on 14.04 (slug: drupal, id: 12394820, distro: Ubuntu)
Dokku v0.3.19 on 14.04 (slug: dokku, id: 12466201, distro: Ubuntu)
MongoDB 3.0.4 on 14.04 (slug: mongodb, id: 12467027, distro: Ubuntu)
node-v0.12.5 on 14.04 (slug: node, id: 12467797, distro: Ubuntu)
Cassandra on 14.04 (slug: cassandra, id: 12540744, distro: Ubuntu)
ELK Logging Stack on 14.04 (slug: elk, id: 12542038, distro: Ubuntu)
GitLab 7.12.2 CE on 14.04 (slug: gitlab, id: 12702571, distro: Ubuntu)
WordPress on 14.04 (slug: wordpress, id: 12740613, distro: Ubuntu)
Django on 14.04 (slug: django, id: 12740667, distro: Ubuntu)
Docker 1.7.1 on 14.04 (slug: docker, id: 12764973, distro: Ubuntu)
MediaWiki 1.24.2 on 14.04 (slug: mediawiki, id: 11716043, distro: Ubuntu)
PHPMyAdmin on 14.04 (slug: phpmyadmin, id: 11730661, distro: Ubuntu)
Redmine on 14.04 (slug: redmine, id: 12438838, distro: Ubuntu)
      eos
    end

    it "acknowledges when personal images are empty when showing default full list" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200&private=true").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images_empty'), :headers => {})

      @cli.options = @cli.options.merge(:show_private_images => true)
      @cli.images

      expect($stdout.string).to eq <<-eos
Showing both private and public images
Private Images:
No private images found

Public Images:
745.1.0 (alpha) (slug: coreos-alpha, id: 12789325, distro: CoreOS)
723.3.0 (beta) (slug: coreos-beta, id: 12789350, distro: CoreOS)
717.3.0 (stable) (slug: coreos-stable, id: 12789351, distro: CoreOS)
5.10 x64 (slug: centos-5-8-x64, id: 6372321, distro: CentOS)
5.10 x32 (slug: centos-5-8-x32, id: 6372425, distro: CentOS)
6.0 x64 (slug: debian-6-0-x64, id: 6372581, distro: Debian)
6.0 x32 (slug: debian-6-0-x32, id: 6372662, distro: Debian)
21 x64 (slug: fedora-21-x64, id: 9640922, distro: Fedora)
14.10 x32 (slug: ubuntu-14-10-x32, id: 9801951, distro: Ubuntu)
14.10 x64 (slug: ubuntu-14-10-x64, id: 9801954, distro: Ubuntu)
10.1 (slug: freebsd-10-1-x64, id: 10144573, distro: FreeBSD)
12.04.5 x64 (slug: ubuntu-12-04-x64, id: 10321756, distro: Ubuntu)
12.04.5 x32 (slug: ubuntu-12-04-x32, id: 10321777, distro: Ubuntu)
7.0 x64 (slug: debian-7-0-x64, id: 10322059, distro: Debian)
7.0 x32 (slug: debian-7-0-x32, id: 10322378, distro: Debian)
7 x64 (slug: centos-7-0-x64, id: 10322623, distro: CentOS)
6.5 x32 (slug: centos-6-5-x32, id: 11523060, distro: CentOS)
6.5 x64 (slug: centos-6-5-x64, id: 11523085, distro: CentOS)
22 x64 (slug: fedora-22-x64, id: 12065782, distro: Fedora)
15.04 x64 (slug: ubuntu-15-04-x64, id: 12658446, distro: Ubuntu)
15.04 x32 (slug: ubuntu-15-04-x32, id: 12660649, distro: Ubuntu)
8.1 x64 (slug: debian-8-x64, id: 12778278, distro: Debian)
8.1 x32 (slug: debian-8-x32, id: 12778337, distro: Debian)
14.04 x32 (slug: ubuntu-14-04-x32, id: 12790298, distro: Ubuntu)
14.04 x64 (slug: ubuntu-14-04-x64, id: 12790328, distro: Ubuntu)
FreeBSD AMP on 10.1 (slug: freebsd-amp, id: 10163059, distro: FreeBSD)
Mumble Server (murmur) on 14.04 (slug: mumble, id: 11132249, distro: Ubuntu)
LAMP on 14.04 (slug: lamp, id: 11146541, distro: Ubuntu)
LEMP on 14.04 (slug: lemp, id: 11146558, distro: Ubuntu)
MEAN on 14.04 (slug: mean, id: 11146864, distro: Ubuntu)
Joomla! 3.4.1 on 14.04 (slug: joomla, id: 11163798, distro: Ubuntu)
Drone on 14.04 (slug: drone, id: 11774848, distro: Ubuntu)
Magento 1.9.1.1 on 14.04 (slug: magento, id: 11876697, distro: Ubuntu)
Ghost 0.6.4 on 14.04 (slug: ghost, id: 12035275, distro: Ubuntu)
Ruby on Rails on 14.04 (Postgres, Nginx, Unicorn) (slug: ruby-on-rails, id: 12035706, distro: Ubuntu)
ownCloud 8.0.4 on 14.04 (slug: owncloud, id: 12333784, distro: Ubuntu)
Drupal 7.38 on 14.04 (slug: drupal, id: 12394820, distro: Ubuntu)
Dokku v0.3.19 on 14.04 (slug: dokku, id: 12466201, distro: Ubuntu)
MongoDB 3.0.4 on 14.04 (slug: mongodb, id: 12467027, distro: Ubuntu)
node-v0.12.5 on 14.04 (slug: node, id: 12467797, distro: Ubuntu)
Cassandra on 14.04 (slug: cassandra, id: 12540744, distro: Ubuntu)
ELK Logging Stack on 14.04 (slug: elk, id: 12542038, distro: Ubuntu)
GitLab 7.12.2 CE on 14.04 (slug: gitlab, id: 12702571, distro: Ubuntu)
WordPress on 14.04 (slug: wordpress, id: 12740613, distro: Ubuntu)
Django on 14.04 (slug: django, id: 12740667, distro: Ubuntu)
Docker 1.7.1 on 14.04 (slug: docker, id: 12764973, distro: Ubuntu)
MediaWiki 1.24.2 on 14.04 (slug: mediawiki, id: 11716043, distro: Ubuntu)
PHPMyAdmin on 14.04 (slug: phpmyadmin, id: 11730661, distro: Ubuntu)
Redmine on 14.04 (slug: redmine, id: 12438838, distro: Ubuntu)
      eos
    end

    it "acknowledges when personal images are empty when just show private images flag given" do
      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images'), :headers => {})

      stub_request(:get, "https://api.digitalocean.com/v2/images?per_page=200&private=true").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer foo', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
         to_return(:status => 200, :body => fixture('show_images_empty'), :headers => {})

      @cli.options = @cli.options.merge(:show_just_private_images => true)
      @cli.images

      expect($stdout.string).to eq <<-eos
Showing just private images
Private Images:
No private images found
      eos
    end
  end

end

