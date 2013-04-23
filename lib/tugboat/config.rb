require 'singleton'

module Tugboat
  # This is the configuration object. It reads in configuration
  # from a .tugboat file located in the user's home directory

  class Configuration
    include Singleton
    attr_reader :data
    attr_reader :path

    FILE_NAME = '.tugboat'
    DEFAULT_SSH_KEY_PATH = '.ssh/id_rsa'
    DEFAULT_SSH_PORT = '22'

    def initialize
      @path = File.join(File.expand_path("~"), FILE_NAME)
      @data = self.load_config_file
    end

    # If we can't load the config file, self.data is nil, which we can
    # check for in CheckConfiguration
    def load_config_file
      require 'yaml'
      YAML.load_file(@path)
    rescue Errno::ENOENT
      return
    end

    def client_key
      @data['authentication']['client_key']
    end

    def api_key
      @data['authentication']['api_key']
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

    # Allow the path to be set.
    def path=(path)
      @path = path
      path
    end

    # Re-runs initialize
    def reset!
      self.send(:initialize)
    end

    # Re-loads the config
    def reload!
      @data = self.load_config_file
    end

    # Writes a config file
    def create_config_file(client, api, ssh_key_path, ssh_user)
      # Default SSH Key path
      if ssh_key_path.empty?
        ssh_key_path = File.join(File.expand_path("~"), DEFAULT_SSH_KEY_PATH)
      end

      if ssh_user.empty?
        ssh_user = ENV['USER']
      end

      if ssh_port.empty?
        ssh_port = DEFAULT_SSH_PORT
      end

      require 'yaml'
      File.open(@path, File::RDWR|File::TRUNC|File::CREAT, 0600) do |file|
        data = {"authentication" => { "client_key" => client, "api_key" => api },
                "ssh" => { "ssh_user" => ssh_user, "ssh_key_path" => ssh_key_path , "ssh_port" => ssh_port}}
        file.write data.to_yaml
      end
    end

  end
end
