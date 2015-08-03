go = ARGV
require_relative "redis_object"

puts go

if go[0] == 'kill'
puts "Killing Redis wait set...."
r = HRedis.new
r.kill_wait_set
end