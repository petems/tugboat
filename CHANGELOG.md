## 0.0.4 (unreleased)

BUG FIXES:

  - Fix a syntax error caused by the order of arguments on `snapshot`.
  This changes the arugment order and is a breaking change [GH-10].

IMPROVEMENTS:

  - Added a warning for snapshotting a droplet in a non-powered off
  state. DigitalOcean currently doesn't return an error from their API.

## 0.0.3 (April 15, 2013)

Initial release.
