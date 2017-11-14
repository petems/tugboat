require 'singleton'

module Tugboat
  # This is the configuration object. It reads in configuration
  # from a .tugboat file located in the user's home directory

  class Configuration
    include Singleton
    attr_reader :data
    attr_reader :path

    FILE_NAME = '.tugboat'.freeze
    DEFAULT_SSH_KEY_PATH = '.ssh/id_rsa'.freeze
    DEFAULT_SSH_PORT = '22'.freeze
    DEFAULT_REGION = 'nyc2'.freeze
    DEFAULT_IMAGE = 'ubuntu-14-04-x64'.freeze
    DEFAULT_SIZE = '512mb'.freeze
    DEFAULT_SSH_KEY = ''.freeze
    DEFAULT_IP6 = 'false'.freeze
    DEFAULT_PRIVATE_NETWORKING = 'false'.freeze
    DEFAULT_BACKUPS_ENABLED = 'false'.freeze
    DEFAULT_USER_DATA = nil
    DEFAULT_TIMEOUT = 90

    # Load config file from current directory, if not exit load from user's home directory
    def initialize
      @path = File.join(File.expand_path('.'), FILE_NAME)
      unless File.exist?(@path)
        @path = (ENV['TUGBOAT_CONFIG_PATH'] || File.join(File.expand_path('~'), FILE_NAME))
      end
      @data = load_config_file
    end

    # If we can't load the config file, self.data is nil, which we can
    # check for in CheckConfiguration
    def load_config_file
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      return
    end

    def access_token
      env_access_token || @data['authentication']['access_token']
    end

    def ssh_key_path
      @data['ssh']['ssh_key_path']
    end

    def ssh_user
      @data['ssh']['ssh_user']
    end

    def ssh_port
      @data['ssh']['ssh_port']
    end

    def use_public_ip
      @data['use_public_ip']
    end

    def default_region
      @data['defaults'].nil? ? DEFAULT_REGION : @data['defaults']['region']
    end

    def default_image
      @data['defaults'].nil? ? DEFAULT_IMAGE : @data['defaults']['image']
    end

    def default_size
      @data['defaults'].nil? ? DEFAULT_SIZE : @data['defaults']['size']
    end

    def default_ssh_key
      @data['defaults'].nil? ? DEFAULT_SSH_KEY : @data['defaults']['ssh_key']
    end

    def default_ip6
      @data['defaults'].nil? ? DEFAULT_IP6 : @data['defaults']['ip6']
    end

    def default_user_data
      @data['defaults'].nil? ? DEFAULT_USER_DATA : @data['defaults']['user_data']
    end

    def default_private_networking
      @data['defaults'].nil? ? DEFAULT_PRIVATE_NETWORKING : @data['defaults']['private_networking']
    end

    def default_backups_enabled
      @data['defaults'].nil? ? DEFAULT_BACKUPS_ENABLED : @data['defaults']['backups_enabled']
    end

    def env_access_token
      ENV['DO_API_TOKEN'] unless ENV['DO_API_TOKEN'].to_s.empty?
    end

    def timeout
      @data['timeout'].nil? ? DEFAULT_TIMEOUT : @data['timeout']
    end

    # Re-runs initialize
    def reset!
      send(:initialize)
    end

    # Re-loads the config
    def reload!
      @data = load_config_file
    end

    # Writes a config file
    def create_config_file(access_token, ssh_key_path, ssh_user, ssh_port, region, image, size, ssh_key, private_networking, backups_enabled, ip6)
      # Default SSH Key path
      ssh_key_path = File.join('~', DEFAULT_SSH_KEY_PATH) if ssh_key_path.empty?

      ssh_user = 'root' if ssh_user.empty?

      ssh_port = DEFAULT_SSH_PORT if ssh_port.empty?

      region = DEFAULT_REGION if region.empty?

      image = DEFAULT_IMAGE if image.empty?

      size = DEFAULT_SIZE if size.empty?

      default_ssh_key = DEFAULT_SSH_KEY if ssh_key.empty?

      if private_networking.empty?
        private_networking = DEFAULT_PRIVATE_NETWORKING
      end

      backups_enabled = DEFAULT_BACKUPS_ENABLED if backups_enabled.empty?

      ip6 = DEFAULT_IP6 if ip6.empty?

      require 'yaml'
      File.open(@path, File::RDWR | File::TRUNC | File::CREAT, 0o600) do |file|
        data = {
          'authentication' => {
            'access_token' => access_token
          },
          'ssh' => {
            'ssh_user' => ssh_user,
            'ssh_key_path' => ssh_key_path,
            'ssh_port' => ssh_port
          },
          'defaults' => {
            'region' => region,
            'image' => image,
            'size' => size,
            'ssh_key' => ssh_key,
            'private_networking' => private_networking,
            'backups_enabled' => backups_enabled,
            'ip6' => ip6
          }
        }
        file.write data.to_yaml
      end
    end
  end
end
