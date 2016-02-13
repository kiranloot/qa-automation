class Box
  require 'yaml'
  @user = nil
  @host = nil
  @port = nil
  @redis_url = nil
  @password = nil
  @dbname = nil
  @prefix = nil
  @admin = nil
  @app = nil
  @base_url = nil

  attr_accessor :user, :host, :port, :password, :dbname, :redis_url, :prefix,
                 :admin, :app, :base_url, :recurly_api_key, :recurly_subdomain

  def initialize(env_name = "qa")
    @env_name = env_name
    config_data = YAML.load(File.open('acceptance_tests/support/server_configs.yml'))
    setup(config_data, @env_name)
  end

  def setup(cd, e)
    config_vars = ["user", "host", "port",
                  "password", "dbname", "redis_url",
                  "prefix", "admin", "app", "base_url",
                  "recurly_api_key", "recurly_subdomain"]
    config_vars.each do |v|
      self.instance_variable_set('@' + v, cd[e][v])
    end
  end

end
