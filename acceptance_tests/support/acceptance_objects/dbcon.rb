class DBCon
require 'pg'
require 'time'
require_relative 'box_object'
require_relative "redis_object"

def initialize(box = Box.new(ENV['SITE']))
  @host = box.host
  @port = box.port
  @user = box.user
  @password = box.password
  @dbname = box.dbname
   setup_connection
   @redis = HRedis.new
end

def finish
  @conn.finish
end

def setup_connection
# CONNECT_ARGUMENT_ORDER = %w[host port options tty dbname user password]
  @conn = PG.connect(host: @host, port: @port, dbname: @dbname, user: @user, password: @password )
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

def get_shirt_size(h)
  puts h['sub']
  q = """
    SELECT v.name FROM subscription_variants sv
    JOIN variants v ON sv.variant_id = v.id
    WHERE sv.subscription_id = #{h['sub']}
  """
  results = @conn.exec(q)
  if results.any?
    h['shirt_size'] = results[0]['name']
  end
end

def user_exists?(user_email)
  query = "Select * from users where email = \'#{user_email}\'"
  results = @conn.exec(query)
  results.any?
end

def get_all_coupon_codes
  query = """
    SELECT code FROM coupons
  """
  @conn.exec(query)
end

def poll_for_one_time_coupon_code(promo_id, number_of = 5)
  query = "select code from coupons where promotion_id = #{promo_id}"
  number_of.times do
    results = @conn.exec(query)
    if results.any?
      return results[0]['code']
    end
    sleep(3)
  end
end

def setup_qa_database
  add_inventory_to_all
  add_user_to_db('admin@example.com','$2a$10$gMQ0WYqkPAFZPMJYQTjcZeOWreqJisY0UDypiG.hggS7B2ZYEM93C','admin_users')
  add_cms_user_to_db('cmsadmin@example.com','$2a$10$gMQ0WYqkPAFZPMJYQTjcZeOWreqJisY0UDypiG.hggS7B2ZYEM93C','cms_users')
end

def add_inventory_to_all(units = 600000)
  query = "update inventory_units set total_available = #{units}"
  @conn.exec(query)
end

def sellout_variant(sku)
  variant_id_query = "select id from variants where sku = '#{sku}'"
  id = @conn.exec(variant_id_query)[0]['id']
  query = "update inventory_units set total_available = 0 where variant_id=#{id}" 
  @conn.exec(query)
end

def sellout_product(name)
  skus = get_all_variant_skus_for_product(name)
  skus.each do |sku|
    sellout_variant(sku)
  end
end

def get_all_variant_skus_for_product(name)
  query = "select v.sku from variants v join products p on v.product_id = p.id where p.name = '#{name}'"
  results = @conn.exec(query)
  results_array = []
  results.each do |result|
    results_array << result['sku']
  end
  results_array
end

def add_user_to_db(email, pass_hash, table)
  check_query = """
    SELECT * FROM #{table} WHERE email = '#{email}'
  """
  query = """
    INSERT INTO #{table} (email,encrypted_password,created_at,updated_at) VALUES ('#{email}','#{pass_hash}',current_timestamp, current_timestamp)
  """
  if !@conn.exec(check_query).any?
    @conn.exec(query)
  end
end

def add_cms_user_to_db(email, pass_hash, table)
  check_query = """
    SELECT * FROM #{table} WHERE email = '#{email}'
  """
  query = """
    INSERT INTO #{table} (email,encrypted_password,role,created_at,updated_at) VALUES ('#{email}','#{pass_hash}','admin',current_timestamp, current_timestamp)
  """
  if !@conn.exec(check_query).any?
    @conn.exec(query)
  end
end

def get_richtext_alchemy_essence_id(text)
  query = """
    SELECT id FROM alchemy_essence_richtexts WHERE body LIKE '%#{text}%'
  """
  @conn.exec(query)[0]['id']
end

def set_richtext_alchemy_essence_to(id, body, stripped_body)
  query = """
    UPDATE alchemy_essence_richtexts SET body = '#{body}', stripped_body = '#{stripped_body}' WHERE id = #{id}
  """
  @conn.exec(query)
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

def registered_with_active_anime
  registered_one_active('Anime Crate')
end

def registered_with_active_level_up
  registered_one_active('Level Up Accessories')
end

def registered_with_active_pets
  registered_one_active('Pets Crate')
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

def get_plan_title(h, sub_id)
  q = plan_title_query(sub_id)
  @conn.exec(q) do |result|
    result.each do |row|
      h["plan_name"] = row["title"]
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

def plan_title_query(sub_id)
  q = """
  select * from subscriptions s
  join plans p on s.plan_id = p.id
  where s.id = '#{sub_id}';
  """
end

def plan_months_query(sub_id)
  q = """
  select period from plans
  where id in (select plan_id from
  subscriptions where id = '#{sub_id}')
  """
  q
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
      h["first_name"] = row["first_name"]
      h["last_name"] = row["last_name"]
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

def get_variant_id(variant_sku,product_name)
  q = """
    SELECT v.id FROM variants v JOIN products p on v.product_id = p.id
      WHERE p.name = '#{product_name}'
      AND v.sku = '#{variant_sku}'
  """
  @conn.exec(q)[0]['id']
end

def verify_webhooks(webhook_event, webhook_status)
  case webhook_event
  when "subscription creation"
    expected_webhooks = [
      "billing_info_updated_notification",
      "new_subscription_notification",
      "new_invoice_notification",
      "successful_payment_notification",
      "closed_invoice_notification",
      "new_account_notification",
    ]
  end
  expected_webhooks.each do |webhook|
    q = """
      select aasm_state
      from recurly_push_notifications
      where raw_payload like '%#{webhook}%'
      and raw_payload like '%#{$test.user.email}%'
    """
    for n in 1..20
      #puts q
      results = @conn.exec(q)
      if results.any?
        #puts results[0]['aasm_state']
        if results[0]['aasm_state'] == webhook_status
          break
        end
      end
    end
    if results[0]['aasm_state'] != webhook_status
      return false
    end
  end
  return true
end

def billing_from_sub_id(sub_id)
end

def shipping_from_sub_id(sub_id)
end

def check_skipped(sub_id)
  q = """
  select * from subscription_skipped_months
  where subscription_id = '#{sub_id}';
  """
  q
  result = @conn.exec(q)
  result.any?
end


def one_active_query(timestamp, crate_type = 'Core Crate')
t = timestamp
q = """
with actives AS(
select u.email as email, s.user_id, s.subscription_status as status,
s.cancel_at_end_of_period as eop, s.id as subs,
s.next_assessment_at as rebill,
sa.flagged_invalid_at as flagged,
sa.state as shipping_state,
sa.zip as shipping_zip,
ba.state as billing_state,
ba.zip as billing_zip,
p.id as plan_id,
ssm.month_year as skipped_month
from users u
inner join subscriptions s
on s.user_id = u.id
inner join addresses sa
on s.shipping_address_id = sa.id
inner join addresses ba
on s.billing_address_id = ba.id
inner join plans p
on s.plan_id = p.id
left outer join subscription_skipped_months ssm
on s.id = ssm.subscription_id
and s.created_at < '#{t}'
and s.updated_at < '#{t}'
and email like '\\_%@mailinator.com'
and email not like '_updated%'
),

sc AS(select email, count(subs) as c from actives
group by email),

info AS(select email, plan_id, subs, rebill, status, flagged, shipping_state, shipping_zip, billing_state, billing_zip, eop, skipped_month from actives)

select sc.email, c, i.subs, i.rebill from sc
inner join info i on i.email = sc.email
where c = 1
and i.status = 'active'
and i.flagged is NULL
and i.shipping_state = 'CA'
and i.shipping_zip = '90210'
and i.billing_state = 'CA'
and i.billing_zip = '90210'
and i.eop is null
and i.skipped_month is null
and i.plan_id in (
  select pl.id from plans pl join products pr on pl.product_id = pr.id where pr.name = '#{crate_type}' and pl.is_legacy is false and pl.country = 'US'
)
limit 1
"""
q
end

def registered_one_active(crate_type = 'Core Crate', test_run_timestamp = ENV['RUN_TIMESTAMP'])
t = test_run_timestamp
wait_count = 0
@redis.connect
while @redis.should_wait?
  wait_count += 1
end
#puts wait_count
@redis.set_wait
ret_hash = {}

q = one_active_query(t,crate_type)
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
  get_plan_title(ret_hash, ret_hash["sub"])
end

@redis.clear_wait
@redis.quit
if ret_hash["email"] == nil
  return nil
else
  return ret_hash
end

end

def get_inventory_item_id_and_count(product, variant)
  q = """
  SELECT iu.id, iu.variant_id, total_available FROM inventory_units iu
  JOIN variants v on iu.variant_id = v.id
  JOIN products p on v.product_id = p.id
  WHERE p.name = '#{product}'
  AND v.name = '#{variant}';
  """

  results = @conn.exec(q)
  results[0]
end

def get_total_committed(variant_id)
  q = """
  SELECT count(s.*) FROM subscription_variants sv
  LEFT JOIN subscriptions s on sv.subscription_id = s.id
  WHERE sv.variant_id = #{variant_id}
  AND s.subscription_status in ('active', 'past_due');
  """

  results = @conn.exec(q)
  results[0]['count']
end

end
