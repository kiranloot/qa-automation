module InventoryFlagManager
  require_relative '../redis_object'
  @flags = [
      "tests_selling_out_anime_inv",
      "tests_using_anime_inv",
      "tests_selling_out_pets_inv",
      "tests_using_pets_inv",
      "tests_selling_out_gaming_inv",
      "tests_using_gaming_inv",
      "tests_selling_out_firefly_inv",
      "tests_using_firefly_inv",
      "tests_selling_out_dx_inv",
      "tests_using_dx_inv",
      "tests_selling_out_lusocks_inv",
      "tests_using_lusocks_inv",
      "tests_selling_out_lutshirt_inv",
      "tests_using_lushirt_inv"
    ]
  @redis = HRedis.new
  def self.set_all_flags
    @redis.connect
    #List of flags used
    @flags.each do |flag|
      @redis.set(flag,0)
    end
    @redis.quit
  end

  def self.remove_all_flags
    @redis.connect
    @flags.each do |flag|
      @redis.del(flag) if @redis.exists(flag)
    end 
    @redis.quit
  end

  def self.increment_flag(key)
    @redis.connect
    @redis.increment_set(key)
    @redis.quit
  end

  def self.decrement_flag(key)
    @redis.connect
    @redis.decrement_set(key)
    @redis.quit
  end

  def self.zero_or_less?(key)
    @redis.connect
    result = @redis.zero_or_less?(key)
    @redis.quit
    return result
  end
end
