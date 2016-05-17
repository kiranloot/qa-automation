class HRedis
  require 'redis'
  require 'uri'
  
  attr_accessor :url

  def initialize(box = Box.new(ENV['SITE']))
    @url = box.redis_url
    @uri = URI.parse(@url)
  end
  
  def connect
    uri = @uri
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def del(name)
    #deletes the value at key name
    #caution, this will delete entire data sturctures
    @redis.del(name)
  end

  def exists(name)
    @redis.exists(name)
  end

  def set_add(name, value)
    #adds value to set stored at key name.
    #if key does not exist, new set is created at key
    @redis.sadd name, value
  end

  def set(name, value)
    @redis.set name, value
  end

  def set_remove(name, value)
    #removes value to set stored at key name.
    #If key does not exist, or member does not exist, no operation is performed
    @redis.srem name, value
  end

  def set_members(name)
    #returns all members of set at key name
    @redis.smembers(name)
  end

  def is_member(name, value)
    #returns boolean for whether value is a member of key name
    @redis.sismember(name, value)
  end

  def set_wait
    set_add(wait_set, wait)
  end

  def clear_wait
    set_remove(wait_set, wait)
  end

  def wait_set
    "wait_check"
  end

  def wait
    "wait"
  end

  def should_wait?
    is_member(wait_set, wait)
  end

  def kill_wait_set
    del(wait_set) if exists(wait_set)
  end

  def increment_set(key)
    @redis.incr key
  end

  def decrement_set(key)
    @redis.decr key
  end

  def zero_or_more?(key)
    @redis.get(key).to_i >= 0
  end

  def zero_or_less?(key)
    @redis.get(key).to_i <= 0
  end

  def keys
    @redis.keys('*')
  end
  
  def quit
    @redis.quit
  end
end
