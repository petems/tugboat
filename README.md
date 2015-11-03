# Tugboat
[![Build Status](https://travis-ci.org/pearkes/tugboat.png?branch=master)](https://travis-ci.org/pearkes/tugboat)
[![Coverage Status](https://coveralls.io/repos/pearkes/tugboat/badge.png?branch=master)](https://coveralls.io/r/pearkes/tugboat)

A command line tool for interacting with your [DigitalOcean](https://www.digitalocean.com/) droplets.

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

## Usage

### Retrieve a list of your droplets

    $ tugboat droplets
    pearkes-web-001 (ip: 30.30.30.1, status: active, region: nyc2, id: 13231511)
    pearkes-admin-001 (ip: 30.30.30.3, status: active, region: nyc2, id: 13231512)
    pearkes-api-001 (ip: 30.30.30.5, status: active, region: nyc2, id: 13231513)

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

    $ tugboat info -n pearkes-admin-001 --attribute ip --porcelain
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

You can create a new issue [here](https://github.com/pearkes/tugboat/issues/new). Thank you!

## Contributing

See the [contributing guide](CONTRIBUTING.md).