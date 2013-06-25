## 0.0.6 (June 25, 2013)

FEATURES:

  - [Ørjan](https://github.com/blom) added a `start` command, which
  let's you start a droplet. [GH-30]
  - [Ørjan](https://github.com/blom) added a `resize` command, which
  let's you resize a droplet. [GH-40]
  - [Ørjan](https://github.com/blom) added a `password-reset` command
  [GH-45]
  - Added a the `wait` command, allowing you to "wait" for a droplet
  to enter a state. [GH-46]

IMPROVEMENTS:

  - [Ørjan](https://github.com/blom) added an `--ssh-opts` flag, for the
  `ssh` command. [GH-38]
  - Droplet state is checked for some commands. For example, a droplet
  can't be started if it's active. [GH-31]

BUG FIXES:

  - DigitalOcean changed their `image_id`'s, so the defaults for `create`
  were updated. [GH-39]

## 0.0.5 (May 4, 2013)

FEATURES:

  - [Ørjan](https://github.com/blom) added a `regions` command, which
  returns a list of available DigitalOcean regions. You can specify
  which region to use while creating: `tugboat create foobar -r 2`. [GH-18]
  - [Ørjan](https://github.com/blom) added an ssh_user option to the
  `ssh` command. This lets you specify the user to connect as on
  a per-command basis, as well as in your `.tugboat`.
  - [Ørjan](https://github.com/blom) added a `sizes` command, which
  returns a list of available sizes. You can specify which size to
  use while creating: `tugboat create foobar -s 66` [GH-19]
  - [Ørjan](https://github.com/blom) added a `hard` flag to
  `halt` and `restart`. This cycles the Droplet's power. `tugboat restart --hard` [GH-27]

IMPROVEMENTS:

  - Tugboat now returns proper status codes for successes and failures.
  [GH-21]
  - Support for MRI 1.8.7
  - CTRL+C's, SIG-INT's are now caught and quietly kill Tugboat without
  a stacktrace.

## 0.0.4 (April 23, 2013)

BUG FIXES:

  - Fix a syntax error caused by the order of arguments on `snapshot`.
  This changes the argument order and is a breaking change [GH-10].
  - Fix an issue with looking up a droplet by it's `--name`. A variable
  was changed, and because it was shadowed passed inspection.

IMPROVEMENTS:

  - Added a warning for snapshotting a droplet in a non-powered off
  state. DigitalOcean currently doesn't return an error from their API.
  - Added a `--confirm` or `-c` to confirmed actions, like destroy. [GH-7]
  - [Ørjan](https://github.com/blom) added a `--version` command to see
  what version of Tugboat you're using.
  - Substantially more test coverage - all of the commands (except `ssh` are
  now integration tested. [GH-15]

FEATURES:

  - Optionally add a list of ssh_key_ids when creating a droplet. These
  SSH keys will automatically be added to your droplet.
  - Show a list of SSH keys on your account with `tugboat keys`
  - [Phil](https://github.com/PhilETaylor) added the ability to specify
  an `--ssh-port` on `tugboat ssh`, as well as set a default in your `.tugboat` [GH-13]

## 0.0.3 (April 15, 2013)

Initial release.
