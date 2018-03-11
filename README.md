# Tugboat
[![Build Status](https://travis-ci.org/petems/tugboat.svg?branch=master)](https://travis-ci.org/petems/tugboat)
[![Coverage Status](https://coveralls.io/repos/github/petems/tugboat/badge.svg?branch=master)](https://coveralls.io/github/petems/tugboat?branch=master)

A command line tool for interacting with your [DigitalOcean](https://www.digitalocean.com/) droplets.

## History

When Tugboat was created, DigitalOcean was an extremely new cloud provider. They'd only released their public beta back in [2012](https://whoapi.com/blog/1497/fast-growing-digitalocean-is-fueled-by-customer-love/), and their new SSD backed machines only premiered in early [2013](https://techcrunch.com/2013/01/15/techstars-graduate-digitalocean-switches-to-ssd-for-its-5-per-month-vps-to-take-on-linode-and-rackspace/).

Tugboat started out life around that time, [back in April 2013](https://github.com/pearkes/tugboat/commit/f0fbc1f438cce81c286f0e60014dc4393ac95cb6). Back then, there were no official libraries for DigitalOcean, and the 1.0 API was a bit unstable and occasionally flakey.

Since then, DigitalOcean has expanded rapidly and has started offering official libraries.

They now have an offically maintained command-line client called [doctl](https://github.com/digitalocean/doctl).

Some people have asked, **where does that leave Tugboat?**

If you want the bleeding edge of new features and official support from DigitalOcean engineers, **Doctl is the way to go**. However, **as long as there is one other user out there who likes Tugboat and it's workflow, I will try my darndest to maintain this project, investigate bugs, implement new features and merge pull-requests.**

## Installation

    gem install tugboat

Please note that Tugboat version 0.2.0 and up requires Ruby 1.9 or higher.

## Configuration

Run the configuration utility, `tugboat authorize`. You can grab your keys
[here](https://cloud.digitalocean.com/api_access).

    $ tugboat authorize
    Enter your client key: foo
    Enter your API key: bar
    Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa):
    Enter your SSH user (optional, defaults to jack):
    Enter your SSH port number (optional, defaults to 22):

    To retrieve region, image, size and key ID's, you can use the corresponding tugboat command, such as `tugboat images`.
    Defaults can be changed at any time in your ~/.tugboat configuration file.

    Enter your default region ID (optional, defaults to 1 (New York)):
    Enter your default image ID (optional, defaults to 350076 (Ubuntu 13.04 x64)):
    Enter your default size ID (optional, defaults to 66 (512MB)):
    Enter your default ssh key IDs (optional, defaults to '', comma separated string):

    Authentication with DigitalOcean was successful!

This will create a .tugboat file in your home folder (eg. ~/.tugboat).

Tugboat will look for a .tugboat config file first in the current directory you're running it in, then will look for one in the home directory.

An example of a `.tugboat` file:

```yaml
---
authentication:
  access_token: f8sazukxeh729ggxh9gjavvzw5cabdpq95txpzhz6ep6jvtquxztfkf2chyejcsg5
ssh:
  ssh_user: root
  ssh_key_path: "~/.ssh/id_rsa"
  ssh_port: '22'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: ['1234','5678']
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
```



## Usage

### Retrieve a list of your droplets

    $ tugboat droplets
    pearkes-web-001 (ip: 30.30.30.1, status: active, region: nyc2, id: 13231511)
    pearkes-admin-001 (ip: 30.30.30.3, status: active, region: nyc2, id: 13231512)
    pearkes-api-001 (ip: 30.30.30.5, status: active, region: nyc2, id: 13231513)

If you wish to use the droplet listing as part of scripting or munging output, you can use the `--porcelain`:

    $ tugboat droplets --attribute=ip4
    pearkes-web-001,30.30.30.1
    pearkes-admin-001,30.30.30.3
    pearkes-api-001,30.30.30.5

Or `--attribute` parameter:

    $ tugboat droplets --porcelain
    name pearkes-web-001
    id 13231515
    status active
    ip4 330.30.30.1
    region lon1
    image 6918990
    size 1gb
    backups_active false

    name pearkes-admin-001
    id 13231513
    status active
    ip4 30.30.30.3
    region lon1
    image 6918990
    size 1gb
    backups_active false

    name pearkes-web-001
    id 13231514
    status active
    ip4 30.30.30.5
    region lon1
    image 6918990
    size 1gb
    backups_active true


### Fuzzy name matching

You can pass a unique fragment of a droplets name for interactions
throughout `tugboat`.

    $ tugboat restart admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)
    Queuing restart for 13231512 (pearkes-admin-001)...done

tugboat handles multiple matches as well:

    $ tugboat restart pearkes
    Droplet fuzzy name provided. Finding droplet ID...Multiple droplets found.

    0) pearkes-web-001  (13231511)
    1) pearkes-admin-001 (13231512)
    2) pearkes-api-001 (13231513)

    Please choose a droplet: ["0", "1", "2"] 0
    Queuing restart for 13231511 (pearkes-web-001)...done

### SSH into a droplet

*You can configure an SSH username and key path in `tugboat authorize`,
or by changing your `~/.tugboat`.*

This lets you ssh into a droplet by providing it's name, or a partial
match.

    $ tugboat ssh admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)
    Executing SSH (pearkes-admin-001)...
    Welcome to Ubuntu 12.10 (GNU/Linux 3.5.0-17-generic x86_64)
    pearkes@pearkes-admin-001:~#

### SCP files to droplet

*You can configure an SSH username and key path in `tugboat authorize`,
or by changing your `~/.tugboat`.*

This lets you scp a file into a droplet by providing it's name, or a partial
match.

    $ tugboat scp test-scp /tmp/foo /tmp/bar
    Droplet fuzzy name provided. Finding droplet ID...done, 72025053 (test-scp)
    Executing SCP on Droplet (test-scp)...
    Attempting SCP with `scp -i /Users/petems/.ssh/digital_ocean /tmp/foo root@132.61.164.113:/tmp/bar`
    foo
                                                  100%    0     0.0KB/s   00:00

### Create a droplet

    $ tugboat create pearkes-www-002 -s 512mb -i ubuntu-12-04-x64 -r nyc2 -k 11251
    Queueing creation of droplet 'pearkes-www-002'...done

### Info about a droplet

    $ tugboat info admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)

    Name:             pearkes-admin-001
    ID:               13231512
    Status:           active
    IP:               30.30.30.3
    Backups Active:   false
    IP6:              2A03:B0C0:0001:00D0:0000:0000:0308:D001
    Region:           London 1 - lon1
    Image:            6918990 - ubuntu-14-04-x64
    Size:             1GB

Print info in machine-readable format. The ``--porcelain`` flag silences extra output for easy parsing. Fuzzy name matching is not supported with the ``--porcelain`` flag.

    $ tugboat info -n pearkes-admin-001 --porcelain
    name pearkes-admin-001
    id 13231512
    status active
    ip4 30.30.30.3
    region lon1
    image 6918990
    size 1gb
    backups_active false

Print a single attribute.

    $ tugboat info -n pearkes-admin-001 --attribute ip --porcelain
    30.30.30.3


### Destroy a droplet

    $ tugboat destroy pearkes-www-002
    Droplet fuzzy name provided. Finding droplet ID...done, 13231515 (pearkes-www-002)
    Warning! Potentially destructive action. Please confirm [y/n]: y
    Queuing destroy for 13231515 (pearkes-www-002)...done

### Restart a droplet

    $ tugboat restart admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)
    Queuing restart for 13231512 (pearkes-admin-001)...done

### Shutdown a droplet

    $ tugboat halt admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)
    Queuing shutdown for 13231512 (pearkes-admin-001)...done

### Snapshot a droplet

    $ tugboat snapshot test-admin-snaphot admin
    Queuing snapshot 'test-admin-snapshot' for 13231512 (pearkes-admin-001)...done

### Resize a droplet

    $ tugboat resize admin -s 66
    Queuing resize for 13231512 (pearkes-admin-001)...done

### Enabling backups on a droplet

    $ tugboat backup_config admin --on
    Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
    Backup action enable backups is complete

### Disabling backups on a droplet

    $ tugboat backup_config admin --off
    Droplet fuzzy name provided. Finding droplet ID...done\e[0m, 6918990 (example.com)
    Backup action disable backups is complete

### List Available Images

You can list all images

    $ tugboat images
    Showing both private and public images
    Private Images:
    My application image (id: 6376601, distro: Ubuntu)

    Public Images:
    745.1.0 (alpha) (slug: coreos-alpha, id: 12789325, distro: CoreOS)
    723.3.0 (beta) (slug: coreos-beta, id: 12789350, distro: CoreOS)
    717.3.0 (stable) (slug: coreos-stable, id: 12789351, distro: CoreOS)
    ....

Or just list images that you have created.

    $ tugboat images --show_just_private_images # or -p
    Showing just private images
    Private Images:
    My application image (id: 6376601, distro: Ubuntu)
    ....

### List Available Sizes

    $ tugboat sizes
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
    ...

### List Available Regions

    $ tugboat regions
    Regions:
    Amsterdam 1 (slug: ams1)
    Amsterdam 2 (slug: ams2)
    Amsterdam 3 (slug: ams3)
    London 1 (slug: lon1)
    New York 1 (slug: nyc1)
    New York 2 (slug: nyc2)
    New York 3 (slug: nyc3)
    San Francisco 1 (slug: sfo1)
    Singapore 1 (slug: sgp1)

### Add SSH keys

    $ tugboat add-key digitalocean
    Possible public key paths from /Users/pearkes/.ssh:

    /Users/pearkes/.ssh/digitalocean.pub
    /Users/pearkes/.ssh/fog.pub
    /Users/pearkes/.ssh/github.pub
    /Users/pearkes/.ssh/id_rsa.pub
    /Users/pearkes/.ssh/terraform.pub

    Enter the path to your SSH key: /Users/petersouter/.ssh/digitalocean.pub
    Queueing upload of SSH key 'digitalocean'...SSH Key uploaded

    Name: digitalocean
    ID: 1384812
    ...

### List SSH Keys

    $ tugboat keys
    Keys:
    Name: pearkes, (id: 231192), fingerprint: 3b:16:bf:e4:8b:00:8b:b8:59:8c:a9:d3:f0:19:45:fa
    ...

### Wait for Droplet State

Sometimes you want to wait for a droplet to enter some state, for
example "off".

    $ tugboat wait admin --state off
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)
    Waiting for droplet to become off....
    ...

This will simply block until the droplet returns a state of "off".
A period will be printed after each request.

## Help

If you're curious about command flags for a specific command, you can
ask tugboat about it.

    $ tugboat help restart


For a complete overview of all of the available commands, run:

    $ tugboat help

Depending on your local configuration, you may need to install a CA bundle (OS X only) using [homebrew](http://brew.sh/) to communicate with DigitalOcean through SSL/TLS:

    $ brew install curl-ca-bundle

After installation, source the bundle path in your `.bash_profile`/`.bashrc`:

    export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

## Reporting Bugs

Yes, please!

You can create a new issue [here](https://github.com/pearkes/tugboat/issues/new). To help with the investigation of your issue, you can set the environment variable DEBUG to give verbose Faraday logging.

* DEBUG=1 is full unredacted
* DEBUG=2 redacts private keys from the log.

Example:

```bash
DEBUG=2 bundle exec tugboat regions
I, [2015-12-06T12:04:27.148922 #92772]  INFO -- : Started GET request to: https://api.digitalocean.com/v2/regions?per_page=200
D, [2015-12-06T12:04:27.149334 #92772] DEBUG -- : Request Headers:
----------------
Authorization : Bearer [TOKEN REDACTED]
Content-Type  : application/json
User-Agent    : Faraday v0.9.2

Request Body:
-------------
{
  "regions": [
    {
      "name": "New York 1",
      "slug": "nyc1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Amsterdam 1",
      "slug": "ams1",
      "sizes": [
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb"
      ],
      "features": [
        "backups"
      ],
      "available": true
    },
    {
      "name": "San Francisco 1",
      "slug": "sfo1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "New York 2",
      "slug": "nyc2",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Amsterdam 2",
      "slug": "ams2",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Singapore 1",
      "slug": "sgp1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "London 1",
      "slug": "lon1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "New York 3",
      "slug": "nyc3",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Amsterdam 3",
      "slug": "ams3",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Frankfurt 1",
      "slug": "fra1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    },
    {
      "name": "Toronto 1",
      "slug": "tor1",
      "sizes": [
        "32gb",
        "16gb",
        "2gb",
        "1gb",
        "4gb",
        "8gb",
        "512mb",
        "64gb",
        "48gb"
      ],
      "features": [
        "private_networking",
        "backups",
        "ipv6",
        "metadata"
      ],
      "available": true
    }
  ],
  "links": {
  },
  "meta": {
    "total": 11
  }
}
```

## Contributing

See the [contributing guide](CONTRIBUTING.md).
