Feature: config
  In order to easily load DigitalOcean config
  As a user
  I should be able to load tugboat config from a .tugboat in the current directory

  Scenario:
    Given a file named ".tugboat" with:
      """
---
authentication:
  access_token: FOO
ssh:
  ssh_user: janedoe
  ssh_key_path: "/Users/janedoe/.ssh/id_rsa"
  ssh_port: '22'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: ''
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
      """
    When I run `tugboat config`
    Then the exit status should not be 1
    And the output should contain "ssh_user: janedoe"
