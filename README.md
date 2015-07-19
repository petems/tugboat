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
    Enter your default ssh key ID (optional, defaults to none):

    Authentication with DigitalOcean was successful!

This will create a .tugboat file in your home folder (eg. ~/.tugboat).

Tugboat will look for a .tugboat config file first in the current directory you're running it in, then will look for one in the home directory.

## Usage

### Retrieve a list of your droplets

    $ tugboat droplets
    pearkes-web-001 (ip: 30.30.30.1, status: active, region: 1, id: 13231511)
    pearkes-admin-001 (ip: 30.30.30.3, status: active, region: 1, id: 13231512)
    pearkes-api-001 (ip: 30.30.30.5, status: active, region: 1, id: 13231513)

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

    $ tugboat create pearkes-www-002 -s 64 -i 2676 -r 2 -k 11251
    Queueing creation of droplet 'pearkes-www-002'...done

### Info about a droplet

    $ tugboat info admin
    Droplet fuzzy name provided. Finding droplet ID...done, 13231512 (pearkes-admin-001)

    Name:             pearkes-admin-001
    ID:               13231512
    Status:           active
    IP:               30.30.30.3
    Region ID:        1
    Image ID:         25489
    Size ID:          66
    Backups Active:   false

Print info in machine-readable format. The ``--porcelain`` flag silences extra output for easy parsing. Fuzzy name matching is not supported with the ``--porcelain`` flag.

    $ tugboat info -n pearkes-admin-001 --attribute ip --porcelain
    name pearkes-admin-001
    id 13231512
    status active
    ip 30.30.30.3
    region_id 1
    image_id 25489
    size_id 66
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

You can list images that you have created.

    $ tugboat images
    My Images:
    pearkes-admin-001 2013-05-19 (id: 13231512, distro: Ubuntu)
    ....

Optionally, list images provided by DigitalOcean as well.

    $ tugboat images --global
    My Images:
    pearkes-admin-001 2013-05-19 (id: 13231512, distro: Ubuntu)
    ....
    Global Images:
    CentOS 5.8 x64 (id: 1601, distro: CentOS)
    ...

### List Available Sizes

    $ tugboat sizes
    Sizes:
    512MB (id: 66)
    1GB (id: 63)
    ...

### List Available Regions

    $ tugboat regions
    Regions:
    New York 1 (id: 1) (slug: nyc1)
    Amsterdam 1 (id: 2) (slug: ams1)
    San Francisco 1 (id: 3) (slug: sfo1)

### List SSH Keys

    $ tugboat keys
    Keys:
    pearkes (id: 10501)
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

It's very helpful if you can run `DEBUG=1 tugboat ...` with the command
that is causing you issues, and then include that in the issue.

You can create a new issue [here](https://github.com/pearkes/tugboat/issues/new). Thank you!

## Contributing

See the [contributing guide](CONTRIBUTING.md).

