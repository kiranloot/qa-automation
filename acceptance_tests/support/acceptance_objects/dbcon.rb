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
  query = "Select * from users where user_email = #{user_email}"
  @conn.exec(query)
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

def registered_one_active(test_run_timestamp = ENV['RUN_TIMESTAMP'])
t = test_run_timestamp
while @redis.should_wait?
  puts "waiting..."
end
@redis.set_wait
email = ""
sub = ""
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
      email =  row["email"]
      sub = row["subs"]
    end
  end

  #puts email
  #puts sub

if email 
  alter_sub(sub)
end

@redis.clear_wait

end

end