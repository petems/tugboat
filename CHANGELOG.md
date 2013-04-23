## 0.0.4 (unreleased)

BUG FIXES:

  - Fix a syntax error caused by the order of arguments on `snapshot`.
  This changes the arugment order and is a breaking change [GH-10].

IMPROVEMENTS:

  - Added a warning for snapshotting a droplet in a non-powered off
  state. DigitalOcean currently doesn't return an error from their API.
  - Added a `--confirm` or `-c` to confirmed actions, like destroy.

FEATURES:

   - Optionally add a list of ssh_key_ids when creating a droplet. These
   SSH keys will automatically be added to your droplet.
   - Show a list of SSH keys on your account with `tugboat keys`

## 0.0.3 (April 15, 2013)

Initial release.
