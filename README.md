# Tugboat

A command line tool for interacting with your [DigitalOcean](https://www.digitalocean.com/) droplets.

## Installation

    gem install tugboat

## Configuration

    $ tugboat authorize
    Note: You can get this stuff at digitalocean.com/api_access

    Enter your client key: ...
    Enter your API Key: ...

    Checking...done.

## Usage

### Retrieve a list of your droplets

    $ tugboat list
    pearkes-admin-001 (region: 1, size: 64, image ID: 2676)
    pearkes-www-001 (region: 1, size: 64, image ID: 2561)
    pearkes-api-001 (region: 1, size: 64, image ID: 6321)

### SSH into a droplet

    $ tugboat ssh admin
    Found droplet "pearkes-admin-001"
    Executing SSH...

### SSH into a droplet with multiple matches

    $ tugboat ssh www
    Found multiple droplets:
    1) pearkes-www-001
    2) pearkes-www-002
    Enter droplet number: 2
    Executing SSH...

### Create a droplet

    $ tugboat create -n pearkes-www-002 -s 64 -i 2676 -r 1
    Creating "pearkes-www-002" (region: 1, size: 64, image ID: 2676)...done.


### Destroy a droplet

    $ tugboat destroy admin
    Warning! Potentially destructive action. Please re-enter droplet name. "pearkes-admin-001": ...
    Destroying "pearkes-admin-001"...done.

### Restart a droplet

    $ tugboat restart admin
    Restarting "pearkes-admin-001"...done.

### Shut down a droplet

    $ tugboat halt admin
    Shutting down "pearkes-admin-001"...done.

### Snapshot a droplet

    $ tugboat snapshot admin
    Queuing snapshot for "pearkes-admin-001"...done.

## Contributing

See the [contributing guide](CONTRIBUTING.md).

