Feature: config
  In order to have an easier time connecting to droplets
  As a user
  I should be able to supply an array of ssh keys for a machine

  @vcr
  Scenario: Array of SSH Keys in Config
    Given a '.tugboat' config with data:
"""
---
authentication:
  access_token: f8sazukxeh729ggxh9gjavvzw5cabdpq95txpzhz6ep6jvtquxztfkf2chyejcsg5
ssh:
  ssh_user: bobby_sousa
  ssh_key_path: "~/.ssh/id_rsa"
  ssh_port: '22'
defaults:
  region: nyc2
  image: ubuntu-14-04-x64
  size: 512mb
  ssh_key: ['1234','5678']
  private_networking: 'false'
  backups_enabled: 'false'
  ip6: 'false'
"""
    When I run `tugboat create droplet-with-array-of-keys`
    Then the exit status should not be 1
    And the output should contain "Queueing creation of droplet 'droplet-with-array-of-keys'...Droplet created!"
