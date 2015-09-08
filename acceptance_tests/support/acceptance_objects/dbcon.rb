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


#Assumption: We want the newest subscription's recurly information
def get_recurly_account_id(user_email)
  query = "SELECT recurly_account_id FROM subscriptions where user_id =
            (select id from users where email = '#{user_email}') ORDER BY created_at DESC"
  @conn.exec(query).field_values('recurly_account_id')[0]
end

def get_subscriptions(user_email)
  query = "SELECT u.email as email, s.id as subscription_id, s.plan_id as plan_id
            FROM subscriptions s 
            JOIN users u on s.user_id = u.id
            WHERE u.email = \'#{user_email}\'"
  @conn.exec(query)
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
      send("#{type}_from_hash", sub) if sub.class == Hash
      send("#{type}_from_sub_id", sub) if sub.class == String
end

def get_plan_months(h, sub_id)
  q = plan_months_query(sub_id)
  @conn.exec(q) do |result|
    result.each do |row|
      h["plan_months"] = row["period"]
    end
  end
end

def get_shirt_size(h)
  q = shirt_size_query(h["sub"])
  @conn.exec(q) do |result|
    result.each do |row|
      h["shirt_size"] = row["shirt_size"]
    end
  end
end

def shirt_size_query(sub_id)
   q = """
   select shirt_size from subscriptions
   where id = '#{sub_id}';
   """
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

def plan_months_query(sub_id)
  q = """
  select period from plans
  where id in (select plan_id from
  subscriptions where id = '#{sub_id}')
  """
end

def billing_from_hash(h)
  q = billing_query(h["sub"].to_s)
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

def one_active_query(timestamp)
t = timestamp
q = """
with actives AS(
select u.email as email, s.user_id, s.subscription_status as status, 
s.cancel_at_end_of_period as eop, s.id as subs,
s.next_assessment_at as rebill from users u
inner join subscriptions s
on s.user_id = u.id
where s.cancel_at_end_of_period is null
and s.created_at::date < '#{t}'::date
and s.updated_at::date < '#{t}'::date
and email like '\\_%' 
),

sc AS(select email, count(subs) as c from actives
group by email),

info AS(select email, subs, rebill, status from actives)

select sc.email, c, i.subs, i.rebill from sc 
inner join info i on i.email = sc.email
where c = 1
and i.status = 'active'
limit 1

"""
q
end


def registered_one_active(test_run_timestamp = ENV['RUN_TIMESTAMP'])
t = test_run_timestamp
wait_count = 0
@redis.connect
while @redis.should_wait?
  wait_count += 1
end
#puts wait_count
@redis.set_wait
ret_hash = {}

q = one_active_query(t)

  @conn.exec(q) do |result|
    result.each do |row|
      ret_hash["email"] =  row["email"]
      ret_hash["sub"] = row["subs"]
      ret_hash["rebill_date_db"] = row["rebill"]
    end
  end

if ret_hash["email"]
  alter_sub(ret_hash["sub"])
  get_shirt_size(ret_hash)
  get_address("billing", ret_hash)
  get_address("shipping", ret_hash)
  get_plan_months(ret_hash, ret_hash["sub"])
end

@redis.clear_wait
@redis.quit
if ret_hash["email"] = nil
  return nil
else
  return ret_hash
end

end

end
