require 'thor'

module Tugboat
  autoload :Middleware, "tugboat/middleware"

  class CLI < Thor
    include Thor::Actions
    ENV['THOR_COLUMNS'] = '120'

    !check_unknown_options

    class_option :quiet, type: :boolean, aliases: "-q"

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

    You can retrieve your credentials from https://cloud.digitalocean.com/api_access

    Optionally, you can configure the default SSH key path and username
    used for `tugboat ssh`. These default to '~/.ssh/id_rsa' and the
    $USER environment variable.
    "
    def authorize
      Middleware.sequence_authorize.call({
        "tugboat_action" => __method__,
        "user_quiet" => options[:quiet]
        })
    end

    desc "config", "Show your current config information"
    long_desc "This shows the current information in the .tugboat config
    being used by the app
    "
    method_option "hide",
                  :type => :boolean,
                  :default => true,
                  :aliases => "-h",
                  :desc => "Hide your API keys"
    def config
      Middleware.sequence_config.call({
        "tugboat_action" => __method__,
        "user_hide_keys" => options[:hide],
        })
    end

    desc "verify", "Check your DigitalOcean credentials"
    long_desc "This tests that your credentials created by the \`authorize\`
    command that are stored in ~/.tugboat are correct and allow you to connect
    to the API without errors.
    "
    def verify
      Middleware.sequence_verify.call({
        "tugboat_action" => __method__,
        "user_quiet" => options[:quiet]
        })
    end

    method_option "include_urls",
                  :type => :boolean,
                  :default => false,
                  :aliases => "-i",
                  :desc => "Include URLs for the droplets (can be opened in a browser)"
    desc "droplets [OPTIONS]", "Retrieve a list of your droplets"
    def droplets
      Middleware.sequence_list_droplets.call({
        "tugboat_action" => __method__,
        "user_quiet" => options[:quiet],
        "include_urls" => options["include_urls"]
        })
    end

    desc "images [OPTIONS]", "Retrieve a list of images"
    method_option "show_just_private_images",
                  :type => :boolean,
                  :default => false,
                  :aliases => "-p",
                  :desc => "Show just private images"
    def images
      Middleware.sequence_list_images.call({
        "tugboat_action" => __method__,
        "user_show_just_private_images" => options[:show_just_private_images],
        "user_quiet" => options[:quiet]
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
    method_option "use_private_ip",
                  :type => :boolean,
                  :aliases => "-t",
                  :desc => "Use Private IP while private IP is present",
                  :default => false
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
                  :aliases => [ "-c", "-y" ,],
                  :desc => "Command to run on the droplet"
    method_option "wait",
                  :type => :boolean,
                  :aliases => '-w',
                  :desc => 'Wait for droplet to become active before trying to SSH'
    def ssh(name=nil)
      Middleware.sequence_ssh_droplet.call({
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_droplet_ssh_port" => options[:ssh_port],
        "user_droplet_ssh_user" => options[:ssh_user],
        "user_droplet_use_private_ip" => options[:use_private_ip],
        "user_droplet_ssh_opts" => options[:ssh_opts],
        "user_droplet_ssh_command" => options[:ssh_command],
        "user_droplet_ssh_wait"  => options[:wait],
        "user_quiet" => options[:quiet],
      })
    end

    desc "create NAME", "Create a droplet."
    method_option  "size",
                   :type => :string,
                   :aliases => "-s",
                   :desc => "The size slug of the droplet"
    method_option  "image",
                   :type => :string,
                   :aliases => "-i",
                   :desc => "The image slug of the droplet"
    method_option  "region",
                   :type => :string,
                   :aliases => "-r",
                   :desc => "The region slug of the droplet"
    method_option  "keys",
                   :type => :string,
                   :aliases => "-k",
                   :desc => "A comma separated list of SSH key ids to add to the droplet"
    method_option  "private_networking",
                  :type => :boolean,
                  :aliases => "-p",
                  :desc => "Enable private networking on the droplet"
    method_option  "ip6",
                  :type => :boolean,
                  :aliases => "-l",
                  :desc => "Enable IP6 on the droplet"
    method_option  "user_data",
                  :type => :string,
                  :aliases => "-u",
                  :desc => "Location of a file to read and use as user data"
    method_option  "backups_enabled",
                   :type => :boolean,
                   :aliases => "-b",
                   :desc => "Enable backups on the droplet"

    def create(name)
      if name =~ /^(-{0,2}help|-{1,2}h)/
        help('create')
        return
      end

      Middleware.sequence_create_droplet.call({
        "tugboat_action" => __method__,
        "create_droplet_ssh_key_ids" => options[:keys],
        "create_droplet_size_slug" => options[:size],
        "create_droplet_image_slug" => options[:image],
        "create_droplet_region_slug" => options[:region],
        "create_droplet_private_networking" => options[:private_networking],
        "create_droplet_ip6" => options[:ip6],
        "create_droplet_user_data" => options[:user_data],
        "create_droplet_backups_enabled" => options[:backups_enabled],
        "create_droplet_name" => name,
        "user_quiet" => options[:quiet]
      })
    end

    desc "rebuild FUZZY_NAME IMAGE_NAME", "Rebuild a droplet."
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
                  :aliases => [ "-c", "-y" ,],
                  :desc => "Skip confirmation of the action"
    method_option "image_id",
                  :type => :numeric,
                  :aliases => "-k",
                  :desc => "The ID of the image"
    method_option "image_name",
                  :type => :string,
                  :aliases => "-m",
                  :desc => "The exact name of the image"
    def rebuild(name=nil, image_name=nil)
      Middleware.sequence_rebuild_droplet.call({
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_image_id" => options[:image_id],
        "user_image_name" => options[:image_name],
        "user_image_fuzzy_name" => image_name,
        "user_confirm_action" => options[:confirm],
        "user_quiet" => options[:quiet]
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
                  :aliases => [ "-c", "-y" ,],
                  :desc => "Skip confirmation of the action"
    def destroy(name=nil)
      Middleware.sequence_destroy_droplet.call({
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_confirm_action" => options[:confirm],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
      })
    end

    desc "destroy_image FUZZY_NAME", "Destroy an image"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the image."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the image"
    method_option "confirm",
                  :type => :boolean,
                  :aliases => [ "-c", "-y" ,],
                  :desc => "Skip confirmation of the action"
    def destroy_image(name=nil)
      Middleware.sequence_destroy_image.call({
        "tugboat_action" => __method__,
        "user_image_id" => options[:id],
        "user_image_name" => options[:name],
        "user_image_fuzzy_name" => name,
        "user_confirm_action" => options[:confirm],
        "user_quiet" => options[:quiet]
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_hard" => options[:hard],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_hard" => options[:hard],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
    method_option "attribute",
                  :type => :string,
                  :aliases => "-a",
                  :desc => "The name of the attribute to print."
    method_option "porcelain",
                  :type => :boolean,
                  :desc => "Give the output in an easy-to-parse format for scripts."
    def info(name=nil)
      Middleware.sequence_info_droplet.call({
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet],
        "user_attribute" => options[:attribute],
        "user_porcelain" => options[:porcelain]
      })
    end

    desc "info_image FUZZY_NAME [OPTIONS]", "Show an image's information"
    method_option "id",
                  :type => :string,
                  :aliases => "-i",
                  :desc => "The ID of the image."
    method_option "name",
                  :type => :string,
                  :aliases => "-n",
                  :desc => "The exact name of the image"
    def info_image(name=nil)
      Middleware.sequence_info_image.call({
        "tugboat_action" => __method__,
        "user_image_id" => options[:id],
        "user_image_name" => options[:name],
        "user_image_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_snapshot_name" => snapshot_name,
        "user_quiet" => options[:quiet]
      })
    end

    desc "keys", "Show available SSH keys"
    def keys
      Middleware.sequence_ssh_keys.call({
        "tugboat_action" => __method__,
      })
    end

    desc "add-key KEY-NAME", "Upload an ssh public key to DigitalOcean, to be assigned to a droplet later"
    long_desc "This uploads a ssh-key to DigitalOcean, which you can then assign to a droplet at
    creation time so you can connect to it with the key rather than a password.
    "
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
        "tugboat_action" => __method__,
        "add_key_name" => name,
        "add_key_pub_key" => options[:key],
        "add_key_file_path" => options[:path],
        "user_quiet" => options[:quiet]
      })
    end

    desc "regions", "Show regions"
    def regions
      Middleware.sequence_regions.call({
        "tugboat_action" => __method__,
        "user_quiet" => options[:quiet]
        })
    end

    desc "version", "Show version"
    def version
      say "Tugboat #{Tugboat::VERSION}"
    end

    desc "sizes", "Show available droplet sizes"
    def sizes
      Middleware.sequence_sizes.call({
        "tugboat_action" => __method__,
        "user_quiet" => options[:quiet]
        })
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
                  :type => :string,
                  :aliases => "-s",
                  :required => true,
                  :desc => "The size slug to resize the droplet to"
    def resize(name=nil)
      Middleware.sequence_resize_droplet.call({
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_size" => options[:size],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
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
        "tugboat_action" => __method__,
        "user_droplet_id" => options[:id],
        "user_droplet_name" => options[:name],
        "user_droplet_desired_state" => options[:state],
        "user_droplet_fuzzy_name" => name,
        "user_quiet" => options[:quiet]
      })
    end
  end
end


