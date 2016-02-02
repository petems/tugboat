Feature: config
  In order to have a good experience
  As a user
  I should be given a nice error when a .tugboat file has bad config

  Scenario:
    Given a file named ".tugboat" with:
      """
---
authentication:
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
    When I run `tugboat droplets`
    Then the exit status should be 1
    And the output should contain "ssh_user: janedoe"
