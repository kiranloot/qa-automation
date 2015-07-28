class DBCon
require 'pg'

def initialize
case ENV['SITE']
when "qa"
  @host = 'ec2-54-163-235-165.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'eesbxjstzisznw'
  @password = 'zAtJrRstR9v9HSe6m2OfaKcJ_X'
  @dbname = 'dvtu453rafu2l'
when "staging"
  @host = 'ec2-107-20-244-236.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'xmdwwyhtoinuuh'
  @password = 'XkzB_Xmhh-8-bSt6-baFX1bdef'
  @dbname = 'dfncjqrcpjcklk'
when "qa2"
  @host = 'ec2-54-83-17-8.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'hiajojhakstxil'
  @password = '5rZlE9CkbJwsF_nym9GbeY5ysN'
  @dbname = 'd9n9c0ersnvap8'
when "goliath"
  @host = 'ec2-54-235-146-58.compute-1.amazonaws.com'
  @port = '5432'
  @user = 'tdfutzeugxpsge'
  @password = '6C9E8w6NG_yOW_bD0c9u_IIOfU'
  @dbname = 'd8qmbr1p8vor9i'
end

# CONNECT_ARGUMENT_ORDER = %w[host port options tty dbname user password]
@conn = PG.connect(host: host, port: port, dbname: dbname, user: user, password: password )
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

def registered_with_active
  query = "SELECT u.email, s.sub"
end

end