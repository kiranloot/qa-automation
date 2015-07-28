require 'csv'

SPREE_SUBSCRIPTION_COLUMNS = %i(legacy_user_id email shirt_size plan_id credit_card_vault_token sfirstname slastname saddress1 saddress2 scity sstate scountry szip bfirstname blastname baddress1 baddress2 bcity bstate bcountry bzip)
SUBSCRIPTION_COLUMNS = %i(id customer_id customer_reference customer_name customer_email state product_id next_product_id product_name recurring_price recurring_interval recurring_interval_unit coupon created_at created_at_day created_at_month created_at_year current_period_starts_at current_period_ends_at next_assessment_at trial_started_at trial_ended_at activated_at expires_at canceled_at canceled_at_day canceled_at_month canceled_at_year cancellation_message balance_in_cents balance revenue_in_cents revenue credit_card_masked_number credit_card_type credit_card_first_name credit_card_last_name credit_card_expiration_month credit_card_expiration_year credit_card_vault credit_card_vault_token credit_card_customer_vault_token credit_card_billing_address credit_card_billing_address_2 credit_card_billing_city credit_card_billing_state credit_card_billing_zip credit_card_billing_country shipping_address shipping_address_2 shipping_city shipping_state shipping_zip shipping_country customer_organization customer_phone cancel_at_end_of_period delayed_cancel_at product_version_number updated_at) unless defined? SUBSCRIPTION_COLUMNS

unless defined? ChargifySubscriptionRow
  class ChargifySubscriptionRow < Struct.new(*SUBSCRIPTION_COLUMNS); end
end

unless defined? SpreeSubscriptionRow
  class SpreeSubscriptionRow < Struct.new(*SPREE_SUBSCRIPTION_COLUMNS); end
end

def customer_id_payment_method_token_map
  csv_fname = "#{Rails.root}/lib/tasks/data/braintree_customers_with_default_payment_methods.csv"

  token_hash = {}

  CSV.open( csv_fname, 'r' ) do |csv|
    csv.shift
    csv.each do |row|
      token_hash[row[0]] = row[1]
    end
  end

  token_hash
end


CHARGIFY_PLANS = CSV.parse(File.read("#{Rails.root}/lib/tasks/data/chargify_product_names_ids_handles_20141130.csv"), :headers => true)

namespace :revert_subscriptions do

  #chargify_plans_text = File.read("#{Rails.root}/lib/tasks/assets/chargify_product_names_ids_handles.csv")

=begin
Description:
  The users that were created on the new site have already been migrated back, and now we are migrating their subscriptions.
  This should create their subscriptions in our database, (they have already been created in Chargify)
=end

  desc "Migrate spree subscriptions into legacy lootcrate database"
  task :migrate_spree_subscriptions_to_legacy => :environment do

    token_hash = customer_id_payment_method_token_map

    # LOTS of time is spent sifting though this array.  Should find a way to index it.
    # spree_subs_fname = "#{Rails.root}/lib/tasks/data/spree_subs_with_legacy_id_and_shirt_size_and_address_and_token.csv"
    # spree_subs_fname = "#{Rails.root}/lib/tasks/data/missed.csv"
    spree_subs_fname = "#{Rails.root}/lib/tasks/data/spree_subs_with_legacy_id_and_shirt_size_and_address_and_token_canceled.csv"

    spree_subs = []
    CSV.open(spree_subs_fname,'r') do |csv|
      csv.shift
      csv.each do |row|
        spree_subs << SpreeSubscriptionRow.new(*row)
      end
    end
    count = 0;
    miss = 0;
    hit = 0

    # CSV.open("#{Rails.root}/lib/tasks/data/sub_foo.csv",'r') do |csv|
    CSV.open("#{Rails.root}/lib/tasks/data/subscriptions-lootcrate-20141128-adjuststed.csv",'r') do |csv|
      csv.shift
      csv.each do |ch_sub|
        chargify_row = ChargifySubscriptionRow.new(*ch_sub)
        count += 1
        match, spree_sub = check_for_token_match(chargify_row, spree_subs, token_hash)
        if match
          begin
          create_subscription(chargify_row, spree_sub)
          hit += 1
          rescue => e
            puts "missed with exception (#{e}) on #{chargify_row.customer_email} - #{chargify_row.credit_card_vault_token}"
            miss += 1
          end
        else
          puts "missed on #{chargify_row.customer_email} - #{chargify_row.credit_card_vault_token}"
          miss += 1
        end

        puts "Count: #{count} (hits: #{hit}, misses: #{miss})" if count % 1000 == 0
      end
    end

    puts "Number of chargify users iterated over: #{count}"
    puts "Number of chargify users with no match: #{miss}"
    puts "Number of chargify users with a new subscription created: #{hit}"
    puts "(miss + hit - count = #{miss + hit - count})"
  end

  private

  # given a token from our database database, look for a match in list of spree users
  def check_for_token_match(ch_sub, spree_subs, token_hash)

    # technique 1: really slow
    # spree_subs.each do |spree_sub|
    #   if spree_sub["credit_card_vault_token"] == ch_sub["credit_card_vault_token"]
    #     return true, spree_sub
    #   end
    # end
    # technique 2: still very slow, but maybe ten percent faster than technique 1?
    # sub = spree_subs.find{|spree_sub| token_hash[spree_sub.credit_card_vault_token] == ch_sub.credit_card_vault_token }
    sub = spree_subs.find{|spree_sub| spree_sub.credit_card_vault_token == ch_sub.credit_card_vault_token }
    if !sub.nil?
      return true, sub
    end

    return false
  end

  # Create a subscription record in our database
  def create_subscription(ch_sub, spree_sub)

    subscription = Subscription.new
    subscription.user_id = spree_sub.legacy_user_id

    subscription.shirt_size = convert_shirt_size(spree_sub.shirt_size)
    subscription.customer_id = ch_sub.customer_id
    subscription.plan_id = spree_sub.plan_id
    subscription.cost = ch_sub.recurring_price
    subscription.looter_name = ch_sub.customer_name
    subscription.coupon_code = ch_sub.coupon
    subscription.last_4 = "" # these are all empty in prod
    subscription.created_at = ch_sub.created_at  # not sure if this should be set manually
    subscription.current = nil # these are all null in prod
    subscription.chargify_subscription_id = ch_sub.id
    subscription.subscription_status = ch_sub.state

    puts "creating sub for user: #{spree_sub.legacy_user_id}"
    subscription.save! # for testing Patrick

    subscription.billing_address = create_new_billing_address(spree_sub, subscription.id)
    subscription.shipping_address = create_new_shipping_address(spree_sub, subscription.id)
    subscription.save!
  end

  # the Spree sizes are mushed together like "MXL", we need "M XL" instead
  def convert_shirt_size(size_without_space)
    return  size_without_space[0] + ' ' + size_without_space[1..-1]
  end

  # get a plan object by Chargify's product_id.  This depends on the csv exported from Chargify
  def get_plan(ch_sub)
    plan = nil

    CHARGIFY_PLANS.each do |chargify_plan|
      if chargify_plan['id'] == ch_sub.product_id
        plan = Plan.find_by_name chargify_plan['handle']
      end
    end

    # product = chargify_plans.select{|key, hash| hash["id"] == ch_sub.product_id }
    # plan = Plan.find_by(name: product.handle)
    plan
  end

  # create and return a new billing address
  def create_new_billing_address(spree_sub, sub_id)
    address = BillingAddress.new
    address.line_1 = spree_sub.baddress1
    address.line_2 = spree_sub.baddress2
    address.city = spree_sub.bcity
    address.state = spree_sub.sstate
    address.zip = spree_sub.bzip
    address.type = "BillingAddress"
    address.first_name = spree_sub.bfirstname
    address.last_name = spree_sub.blastname
    address.country = spree_sub.bcountry
    address.subscription_id = sub_id
    address.save!

    address
  end

  # create and return a new shipping address
  def create_new_shipping_address(spree_sub, sub_id)
    address = ShippingAddress.new
    address.line_1 = spree_sub.saddress1
    address.line_2 = spree_sub.saddress2
    address.city = spree_sub.scity
    address.state = spree_sub.sstate
    address.zip = spree_sub.szip
    address.type = "ShippingAddress"
    address.first_name = spree_sub.sfirstname
    address.last_name = spree_sub.slastname
    address.country = spree_sub.scountry
    address.subscription_id = sub_id
    address.save!

    return address
  end

  # split the full_name and use the first two results as first and last names, if no second value exists, use the first value twice.
  def split_full_name(customer_name)
    split_result = customer_name.split
    names = {first_name: '', last_name: ''}

    names['first_name'] = split_result[0].nil? ? 'Loot' : split_result[0]
    names['last_name'] = split_result[1].nil? ? names['first_name'] : split_result[1]
    return names
  end
end
