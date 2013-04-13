require 'singleton'

module Tugboat
  # This is the configuration object. It reads in configuration
  # from a .tugboat file located in the user's home directory

  class Configuration
    include Singleton
    attr_reader :data

    FILE_NAME = '.tugboat'

    def initialize
      @path = File.join(File.expand_path("~"), FILE_NAME)
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

    def client_key
      @data['authentication']['client_key']
    end

    def api_key
      @data['authentication']['api_key']
    end

  end
end
