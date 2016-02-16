Feature: config
  In order to easily load DigitalOcean config
  As a user
  I should be able to supply an ssh key as a number

  @vcr
  Scenario: Single SSH key as number in config
    Given a '.tugboat' config with data:
"""
---
authentication:
  access_token: faketokenazukxeh729ggxh9gjavvzw5cabdpq95txpzhz6ep6jvtquxztfkf2chyejcsg5
ssh:
  ssh_user: root
  ssh_key_path: "~/.ssh/id_rsa"
  ssh_port: '22'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: 27100
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
"""
    When I run `tugboat create number-based-key`
    Then the exit status should not be 1
    And the output should contain "Queueing creation of droplet 'number-based-key'...Droplet created!"
