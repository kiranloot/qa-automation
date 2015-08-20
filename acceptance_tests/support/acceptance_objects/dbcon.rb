class DBCon
require 'pg'
require 'time'
require_relative "redis_object"

def initialize
   self.send("#{ENV['SITE']}")
   setup_connection
   @redis = HRedis.new
end

def finish
  @conn.finish
end

def qa
  @host = 'ec2-107-22-166-14.compute-1.amazonaws.com'
  @port = '5702'
  @user = 'u552tt5ivnp53u'
  @password = 'p6osgimrt812s413vc4081r82j1'
  @dbname = 'd1nl1de06d790v'
end

def setup_connection
# CONNECT_ARGUMENT_ORDER = %w[host port options tty dbname user password]
  @conn = PG.connect(host: @host, port: @port, dbname: @dbname, user: @user, password: @password )
end

def qa2
  @host = 'ec2-54-83-17-8.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'hiajojhakstxil'
  @password = '5rZlE9CkbJwsF_nym9GbeY5ysN'
  @dbname = 'd9n9c0ersnvap8'
end

def staging
  @host = 'ec2-107-20-244-236.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'xmdwwyhtoinuuh'
  @password = 'XkzB_Xmhh-8-bSt6-baFX1bdef'
  @dbname = 'dfncjqrcpjcklk'
end

def goliath
  @host = 'ec2-54-235-146-58.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'tdfutzeugxpsge'
  @password = '6C9E8w6NG_yOW_bD0c9u_IIOfU'
  @dbname = 'd8qmbr1p8vor9i'
end

def local
  @host = 'localhost'
  @port = '5432'
  @dbname = 'lootcrate_development'
end

def exec(query)
  @conn.exec(query) do |result|
    return result
  end
end

def example

  @conn.exec("SELECT * FROM users Limit 100") do |result|
    result.each do |row|
      puts "%s %s %s" %
        row.values_at('id','email', 'account_status')
    end
  end
end

def user_exists?(user_email)
  query = "Select * from users where email = \'#{user_email}\'"
  results = @conn.exec(query)
  results.any?
end

def get_recurly_account_id(user_email)
  query = "SELECT recurly_account_id FROM subscriptions where user_id =
            (select id from users where email = '#{user_email}')"
  @conn.exec(query).getvalue(0,0)
end

def get_subscriptions(user_email)
  query = "SELECT u.email, s.subscription_id, s.plan_name FROM"
end

def alter_sub(sub)
r = rand(999)
q  = """
UPDATE subscriptions
SET name  = 'altered#{r}'
WHERE id = '#{sub}'
"""

q2 = """
UPDATE subscriptions
SET updated_at = now()
WHERE id = '#{sub}'
"""

@conn.exec(q)
@conn.exec(q2)

end

def registered_with_active
  registered_one_active
end

def get_address(type, sub)
      send("#{type}_from_hash", [sub]) if sub.class = Hash
      send("#{type}_from_sub_id", [sub]) if sub.class = String
end

def billing_query(sub_id)
  q = """
  select * from addresses
  where id in (select billing_address_id from subscriptions 
  where id = '#{sub_id}');
  """
  q
end

def shipping_query(sub_id)
  q = """
  select * from addresses
  where id in (select shipping_address_id from subscriptions
  where id = '#{sub_id}');
  """
  q
end

def billing_from_hash(h)
  q = billing_query(h["sub"])
  @conn.exec(q) do |result|
    result.each do |row|
      h["bill_street"] = row["line_1"]
      h["bill_street_2"] = row["line_2"]
      h["bill_state"] = row["state"]
      h["bill_city"] = row["city"]
      h["bill_zip"] = row["zip"]
    end
  end
end

def shipping_from_hash(h)
  q = shipping_query(h["sub"])
  @conn.exec(q) do |result|
    result.each do |row|
      h["ship_street"] = row["line_1"]
      h["ship_street_2"] = row["line_2"]
      h["ship_state"] = row["state"]
      h["ship_city"] = row["city"]
      h["ship_zip"] = row["zip"]
    end

  end
end

def billing_from_sub_id(sub_id)
end

def shipping_from_sub_id(sub_id)
end


def registered_one_active(test_run_timestamp = ENV['RUN_TIMESTAMP'])
t = test_run_timestamp
while @redis.should_wait?
  puts "waiting..."
end
@redis.set_wait
ret_hash = {}
q = """
with actives AS(
select u.email as email, s.user_id, s.subscription_status, s.cancel_at_end_of_period as eop, s.id as subs from users u
inner join subscriptions s
on s.user_id = u.id
where s.subscription_status = 'active'
and s.created_at::date < '#{t}'::date
and s.updated_at::date < '#{t}'::date
and email like '_%')

select email, subs from (select email, subs, eop, count(subs) as c from actives
group by email, subs, eop) as sub_counts
where c = 1
and eop is null 
limit 1;
"""

  @conn.exec(q) do |result|
    result.each do |row|
      ret_hash["email"] =  row["email"]
      ret_hash["sub"] = row["subs"]
    end
  end

if ret_hash["email"]
  alter_sub(sub)
  get_address("billing", ret_hash)
  get_ship_address("shipping", ret_hash)
end

@redis.clear_wait

end

end
