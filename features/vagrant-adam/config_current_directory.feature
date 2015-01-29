Feature: config
  In order to easily load DigitalOcean config
  As a user
  I should be able to load tugboat config from a .tugboat in the current directory

  Scenario:
    Given a file named ".tugboat" with:
      """
---
authentication:
  client_key: FOO
  api_key: BAR
ssh:
  ssh_user: janedoe
  ssh_key_path: "/Users/janedoe/.ssh/id_rsa"
  ssh_port: '22'
defaults:
  region: '8'
  image: '9801950'
  size: '66'
  ssh_key: ''
  private_networking: 'false'
  backups_enabled: 'false'
      """
    When I run `tugboat config`
    Then the exit status should not be 1
    And the output should contain "ssh_user: janedoe"
