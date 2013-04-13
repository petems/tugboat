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

    # Writes a config file
    def create_config_file(client, api)
      require 'yaml'
      File.open(@path, File::RDWR|File::TRUNC|File::CREAT, 0600) do |file|
        data = {"authentication" => {"api_key" => api, "client_key" => client}}
        file.write data.to_yaml
      end
    end

  end
end
