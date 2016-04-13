require 'dalli'
require 'yaml'

class Memcachier
  attr_accessor :cache
  def initialize
    mc_data = YAML.load(File.open(ENV['SERVER_CONFIGS']))[ENV['SITE']]['memcachier']
    @cache = Dalli::Client.new(
      mc_data['server'],
      {
        :username => mc_data['username'],
        :password => mc_data['password'],
        :failover => true,
        :socket_timeout => 1.5,
        :socket_delay => 0.2
      }
    )
  end

  def flush
    @cache.flush
  end
end
