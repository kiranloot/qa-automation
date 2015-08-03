class HRedis
  require 'redis'
  require 'uri'
  
  attr_accessor :url

  def initialize
    @site = ENV['SITE']
    @url = send("url_#{@site}")
    uri = URI.parse(url)
    @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  end

  def url
    @url
  end

  def url_qa
    "redis://redistogo:17af1e3d5398fca6beeb4f7ade155eaa@mummichog.redistogo.com:9636/"
  end

  def url_qa2
    "redis://redistogo:58cd69a7595d7b49495518e54075ef41@hammerjaw.redistogo.com:10397/"
  end

  def url_staging
    "redis://redistogo:68f3acae465908685651c557e65678c4@mummichog.redistogo.com:9637/"
  end

  def url_goliath
    "redis://redistogo:0886abb02a7f885a29fe4aa8ec642b16@mummichog.redistogo.com:10742/"
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
    del(wait_set)
  end

end