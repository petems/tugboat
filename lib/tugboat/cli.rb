require 'thor'

module Tugboat
  autoload :Middleware, "tugboat/middleware"

  class CLI < Thor
    include Thor::Actions
    ENV['THOR_COLUMNS'] = '120'

    !check_unknown_options

    map "--version"      => :version,
        "-v"             => :version,
        "password-reset" => :password_reset

    desc "help [COMMAND]", "Describe commands or a specific command"
    def help(meth=nil)
      super
      if !meth
        say "To learn more or to contribute, please see github.com/pearkes/tugboat"
      end
    end

    desc "authorize", "Authorize a DigitalOcean account with tugboat"
    long_desc "This takes you through a workflow for adding configuration
    details to tugboat. First, you are asked for your API and Client keys,
    which are stored in ~/.tugboat.

    You can retrieve your credentials from digitalocean.com/api_access.

    Optionally, you can configure the default SSH key path and username
    used for `tugboat ssh`. These default to '~/.ssh/id_rsa' and the
    $USER environment variable.
    "
    def authorize
      Middleware.sequence_authorize.call({})
    end

    desc "verify", "Check your DigitalOcean credentials"
    long_desc "This tests that your credentials created by the \`authorize\`
    command that are stored in ~/.tugboat are correct and allow you to connect
    to the API without errors.
    "
    def verify
      Middleware.sequence_verify.call({})
    end

    desc "droplets", "Retrieve a list of your droplets"
    def droplets
      Middleware.sequence_list_droplets.call({})
    end

    desc "images", "Retrieve a list of your images"
    method_option "global",
                  :type => :boolean,
                  :default => false,
                  :aliases => "-g",
                  :desc => "Show global images"
    def images
      Middleware.sequence_list_images.call({
        "user_show_global_images" => options[:global],
        })
    end

    desc "ssh FUZZY_NAME", "SSH into a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "ssh_port",
                  :type => :string,
                  :aliases => "-p",
                  :desc => "The custom SSH Port to connect to"
    method_option "ssh_user",
                  :type => :string,
                  :aliases => "-u",
                  :desc => "Specifies which user to log in as"
    method_option "ssh_opts",
                  :type => :string,
                  :aliases => "-o",
                  :desc => "Custom SSH options"
    method_option "ssh_command",
                  :type => :string,
                  :aliases => "-c",
                  :desc => "Command to run on the droplet"
    def ssh(name=nil)
      Middleware.sequence_ssh_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_droplet_ssh_port" => options[:ssh_port],
        "user_droplet_ssh_user" => options[:ssh_user],
        "user_droplet_ssh_opts" => options[:ssh_opts],
        "user_droplet_ssh_command" => options[:ssh_command]
      })
    end

    desc "create NAME", "Create a droplet."
    method_option  "size",
                   :type => :numeric,
                   :aliases => "-s",
                   :desc => "The size_id of the droplet"
    method_option  "image",
                   :type => :numeric,
                   :aliases => "-i",
                   :desc => "The image_id of the droplet"
    method_option  "region",
                   :type => :numeric,
                   :aliases => "-r",
                   :desc => "The region_id of the droplet"
    method_option  "keys",
                   :type => :string,
                   :aliases => "-k",
                   :desc => "A comma separated list of SSH key ids to add to the droplet"
    def create(name)
      Middleware.sequence_create_droplet.call({
        "create_droplet_size_id" => options[:size],
        "create_droplet_image_id" => options[:image],
        "create_droplet_region_id" => options[:region],
        "create_droplet_ssh_key_ids" => options[:keys],
        "create_droplet_name" => name
      })
    end

    desc "destroy FUZZY_NAME", "Destroy a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "confirm",
                  :type => :boolean,
                  :aliases => "-c",
                  :desc => "Skip confirmation of the action"
    def destroy(name=nil)
      Middleware.sequence_destroy_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_confirm_action" => options[:confirm],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "restart FUZZY_NAME", "Restart a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "hard",
                  :type => :boolean,
                  :aliases => "-h",
                  :desc => "Perform a hard restart"
    def restart(name=nil)
      Middleware.sequence_restart_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_hard" => options[:hard],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "halt FUZZY_NAME", "Shutdown a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "hard",
                  :type => :boolean,
                  :aliases => "-h",
                  :desc => "Perform a hard shutdown"
    def halt(name=nil)
      Middleware.sequence_halt_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_hard" => options[:hard],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "info FUZZY_NAME [OPTIONS]", "Show a droplet's information"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def info(name=nil)
      Middleware.sequence_info_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "snapshot SNAPSHOT_NAME FUZZY_NAME [OPTIONS]", "Queue a snapshot of the droplet."
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def snapshot(snapshot_name, name=nil)
      Middleware.sequence_snapshot_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_snapshot_name" => snapshot_name
      })
    end

    desc "keys", "Show available SSH keys"
    def keys
      Middleware.sequence_ssh_keys.call({})
    end

    desc "add-key NAME", "Upload an ssh public key."
    method_option  "key",
                   :type => :string,
                   :aliases => "-k",
                   :desc => "The string of the key"                   
    method_option "path",
                  :type => :string,
                  :aliases => "-p",
                  :desc => "The path to the ssh key"
    def add_key(name)
      Middleware.sequence_add_key.call({
        "add_key_name" => name,
        "add_key_pub_key" => options[:key],
        "add_key_file_path" => options[:path],
      })
    end

    desc "regions", "Show regions"
    def regions
      Middleware.sequence_regions.call({})
    end

    desc "version", "Show version"
    def version
      say "Tugboat #{Tugboat::VERSION}"
    end

    desc "sizes", "Show available droplet sizes"
    def sizes
      Middleware.sequence_sizes.call({})
    end

    desc "start FUZZY_NAME", "Start a droplet"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def start(name=nil)
      Middleware.sequence_start_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "resize FUZZY_NAME", "Resize a droplet"
    method_option "id",
                  :type => :numeric,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "size",
                  :type => :numeric,
                  :aliases => "-s",
                  :required => true,
                  :desc => "The size_id to resize the droplet to"
    def resize(name=nil)
      Middleware.sequence_resize_droplet.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_size" => options[:size],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "password-reset FUZZY_NAME", "Reset root password"
    method_option "id",
                  :type => :numeric,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    def password_reset(name=nil)
      Middleware.sequence_password_reset.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name
      })
    end

    desc "wait FUZZY_NAME", "Wait for a droplet to reach a state"
    method_option "id",
                  :type => :numeric,
                  :aliases => "-i",
                  :desc => "The ID of the droplet."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the droplet"
    method_option "state",
                  :type => :string,
                  :aliases => "-s",
                  :default => "active",
                  :desc => "The state of the droplet to wait for"
    def wait(name=nil)
      Middleware.sequence_wait.call({
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_desired_state" => options[:state],
        "user_droplet_fuzzy_name" => name
      })
    end
  end
end

