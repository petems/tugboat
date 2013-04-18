# Tugboat
[![Build Status](https://travis-ci.org/pearkes/tugboat.png?branch=master)](https://travis-ci.org/pearkes/tugboat)

A command line tool for interacting with your [DigitalOcean](https://www.digitalocean.com/) droplets.

## Installation

    gem install tugboat

## Configuration

Run the configuration utility, `tugboat authorize`. You can grab your keys
[here](https://www.digitalocean.com/api_access).

    $ tugboat authorize
    Enter your client key: foo
    Enter your API key: bar
    Enter your SSH key path (optional, defaults to ~/.ssh/id_rsa):
    Enter your SSH user (optional, defaults to jack):
    Authentication with DigitalOcean was successful!

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

## Help

If you're curious about command flags for a specific command, you can
ask tugboat about it.

    $ tugboat help restart


For a complete overview of all of the available commands, run:

    $ tugboat help

## Contributing

See the [contributing guide](CONTRIBUTING.md).

