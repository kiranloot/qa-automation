namespace :useraccounts do

  desc 'create orders csv'
  task :orders_csv => :environment do
    puts 'name, email, looter_name, shipping_1, shipping_2, city, state, zip, country, item, chargify_customer_id, chargify_subscription_id, order'

    Subscription.where(subscription_status: ['active', 'past_due']).find_each do |sub|
      user = sub.user
      sa = sub.shipping_address

      puts "\"#{user.full_name}\",\"#{user.email}\",\"#{sub.looter_name}\",\"#{sa.line_1}\",\"#{sa.line_2}\",\"#{sa.city}\",\"#{sa.state}\",\"#{sa.zip}\",\"#{sa.country}\",\"#{sub.shirt_size}\",\"#{sub.customer_id}\",\"#{sub.chargify_subscription_id}\",\"#{sub.id}\""
    end
  end

  desc 'dedupe'
  task :remove_dups => :environment do
    for id in ChargifyCustomer.all.map(&:chargify_customer_id).uniq
      dups = ChargifyCustomer.where(chargify_customer_id: id)
      dups.shift
      dups.destroy_all
    end
  end

  task :fix_users => :environment do
    hash = Subscription.where(subscription_status: 'active')
      .select('customer_id, count(customer_id)')
      .group('customer_id')
      .having('count(customer_id) > 1')
      .count

    puts "#{hash.keys.count} have incorrectly mapped customer-subscription".red

    counts = {}
    users = []

    hash.each_pair do |k,v|
      cc = ChargifyCustomer.find_by_chargify_customer_id(k)
      counts[v].nil? ? counts[v] = 1 : counts[v] += 1
      users << cc.user if cc.user.account_status == 'active'

      user = cc.user
      print "#{user.id.to_s.ljust(7)} | #{user.full_name ? user.full_name.ljust(30) : "".ljust(30)} | #{user.email.ljust(30)} |  [ "
      for customer_id in user.chargify_customer_accounts.map(&:chargify_customer_id)
        if customer_id == k
          print "#{customer_id} ".cyan
        else
          print "#{customer_id} ".red
        end
      end
      puts ']'
    end
  end

  desc 'get shirt sizes'
  task shirt_sizes: :environment do
    puts 'Shirt Sizes'
    puts "Mens   S    | #{Subscription.where(subscription_status: 'active', shirt_size: 'M S').count}"
    puts "Mens   M    | #{Subscription.where(subscription_status: 'active', shirt_size: 'M M').count}"
    puts "Mens   L    | #{Subscription.where(subscription_status: 'active', shirt_size: 'M L').count}"
    puts "Mens   XL   | #{Subscription.where(subscription_status: 'active', shirt_size: 'M XL').count}"
    puts "Mens   XXL  | #{Subscription.where(subscription_status: 'active', shirt_size: 'M XXL').count}"
    puts "Mens   XXXL | #{Subscription.where(subscription_status: 'active', shirt_size: 'M XXXL').count}"
    puts "Womens S    | #{Subscription.where(subscription_status: 'active', shirt_size: 'W S').count}"
    puts "Womens M    | #{Subscription.where(subscription_status: 'active', shirt_size: 'W M').count}"
    puts "Womens L    | #{Subscription.where(subscription_status: 'active', shirt_size: 'W L').count}"
    puts "Womens XL   | #{Subscription.where(subscription_status: 'active', shirt_size: 'W XL').count}"
    puts "Womens XXL  | #{Subscription.where(subscription_status: 'active', shirt_size: 'W XXL').count}"
    puts "Womens XXXL | #{Subscription.where(subscription_status: 'active', shirt_size: 'W XXXL').count}"
  end

  def sync_subscriptions!
    Subscription.sync_or_create_from_chargify
  end

  desc 'sync subscriptions'
  task :sync, [:status, :count] => :environment do |t, args|
    puts args

    args.with_defaults(:count => 1)
    args.with_defaults(:status => 'active')
    count = args[:count].to_i
    status = args[:status]
    puts "Finding #{status.yellow} Users with id's greater than #{count.to_s.yellow}"

    User.where(account_status: status).order(:id).where("id > #{count}").find_each do |user|
      puts "syncer: #{user.id.to_s}".green
      user.sync_subscriptions!
    end
  end

  desc 'sync all subs'
  task :sync_all, [:start_id, :end_id, :type] => [:environment] do |t, args|
    args.with_defaults(:start_id => 0)
    args.with_defaults(:end_id => -1)

    shipping_correct  = 0
    shipping_unsynced = 0
    sync_from_chargify = 0
    sync_to_chargify = 0
    plan_state = 0
    start_id = args[:start_id].to_i
    end_id = args[:end_id].to_i
    total = 0

    Subscription.where(id: (args[:start_id].to_i)..(args[:end_id].to_i)).find_each do |match|
      start_id += 1

      next unless subscription = Chargify::Subscription.find(match.chargify_subscription_id)

      total += 1
      puts "#{total} | id:#{match.id} | charg_sub_id:#{subscription.id}"
      begin
        # sync subscription status and plan handle from chargify
        if subscription.state != match.subscription_status
          plan_state += 1
          plan = Plan.find_by_name(subscription.product.handle)
          puts "#{match.plan_id} -> #{plan.id} | #{match.subscription_status} -> #{subscription.state}"
          match.update_attributes({ subscription_status: subscription.state, plan_id: plan.id })
        end

        customer = subscription.customer
        address  = match.shipping_address
        # sync shipping address to/from chargify
        if in_sync?(address, customer)
          shipping_correct += 1
          next
        else
          shipping_unsynced += 1
          print_summary(total, address, customer, 'yellow')
          # find latest version, sync both
          if address.updated_at < customer.updated_at
            address.sync_from_chargify(customer, args[:type])
            puts 'synced local <- from chargify'.red
            sync_from_chargify += 1
          else
            address.sync_to_chargify(customer, args[:type])
            puts 'synced local -> to chargify'.light_magenta
            sync_to_chargify += 1
          end
        end
      rescue => e
        puts e.inspect.magenta
      end
    end

    # print stats
    # puts "\nWrong Addresses:  #{wrong}".red
    puts "Valid Addresses:  #{shipping_correct}".green
    puts "Plan Status or Handle: #{plan_state}".magenta
    puts "Synced From Chargify: #{sync_from_chargify}".red
    puts "Synced To Chargify: #{sync_to_chargify}".magenta
    puts "Total Processed:  #{total}\n\n"
  end

  desc 'only customer migration from chargify api'
  task :api_direct, [:page] => [:environment] do |t, args|
    puts Benchmark.measure {
      args.with_defaults(:page => 0)
      page = args[:page].to_i
      while customers = get_chargify_customers(page)
        page += 1
        for customer in customers
          if user = User.where("email ILIKE ?", customer.email.strip).first
            puts "User Exists => #{user.id}: #{user.email}"

            # Update with chargify_customer_id
            add_chargify_customer_account(user, customer)
          else
            full_name = "#{customer.first_name} #{customer.last_name}"
            user = User.new(email:      customer.email,
                            full_name:  full_name,
                            created_at: customer.created_at)

            # Save user and add ChargifyCustomer record
            if user.save
              puts "User Created => #{user.id}: #{user.email}".green

              # Update with chargify_customer_id
              add_chargify_customer_account(user, customer)
            else
              puts "Cannot create user #{customer.id} for #{customer.email}".red
              puts user.errors.full_messages.to_yaml.red
            end
          end
        end
      end
      puts "\nPage: #{page}"
    }
  end

  desc 'Sends emails to users with non-active accounts.'
  task :send_activation_email, [:count] => [:environment] do |t, args|
    puts Benchmark.measure {
      users = User.where(encrypted_password: '', reset_password_token: nil, account_status: nil)
      args.with_defaults(:count => users.count)
      count = args[:count].to_i

      # Stats
      active = 0
      inactive = 0

      puts "Inviting #{count.to_s.yellow} users!"

      users[0..count].each do |user|
        if user.is_active?
          SubscriptionMailer.legacy_invite_instructions(user).deliver
          puts "invite sent     | #{user.id} | #{user.email}".green
          #puts user.email.green + " -> active".green
          active += 1
        else
          user.account_status = 'legacy canceled'
          puts "#{user.account_status} | #{user.id} | #{user.email}".red
          inactive += 1
        end
        user.save
      end

      puts "\nInvited (active):   #{active.to_s.green}"
      puts "Ignored (inactive): #{inactive.to_s.red}"
      puts "----------------------------"
      puts "Total: #{(active + inactive).to_s.yellow}\n"
    }
  end

  task :resend_invite => :environment do
    User.where(account_status: 'invited').find_each do |user|
      SubscriptionMailer.reinvite(user).deliver
      puts "invite sent | #{user.id} | #{user.email}".green
    end
  end

  task :looter_info_csv => :environment do
    puts Benchmark.measure {
      csv_text = File.read("#{Rails.root}/looter_info.csv")
      csv = CSV.parse(csv_text, :headers => true)

      csv_out = 'new_looter_info.csv'

      CSV.open(csv_out, 'w') do |new_csv|
        # write headers
        new_csv << ['looter_name', 'email', 'shirt_size', 'created_at', 'updated_at']

        # process and write rows
        csv.each do |survey|
          begin
            row = survey.to_hash

            email = row['email'].try(:downcase)
            looter_name = row['looter_name']
            shirt_size = ShirtSize.from_survey(row['shirt_size'])
            created_at = Time.now
            updated_at = Time.now

            present = email.present? and looter_name.present? and shirt_size.present?

            if present and email.include?("@")
              puts "#{email.ljust(40)} #{looter_name.ljust(30)} #{shirt_size}".green
              new_csv << [email, looter_name, shirt_size, created_at, updated_at]
            # elsif present and not email.include?("@") and looter_name.include?("@")
              # temp = email
              # email = looter_name.downcase
              # looter_name = temp
              # puts "#{email.ljust(40)} #{looter_name.ljust(30)} #{shirt_size}".yellow
              # new_csv << [email, looter_name, shirt_size]
            else
              email = email ? email.ljust(40) : "".ljust(40)
              looter_name = looter_name ? looter_name.ljust(30) : "".ljust(30)
              puts "#{email} #{looter_name} #{shirt_size}".red
            end
          rescue => e
            puts "#{row} - #{e}".magenta
          end
        end
      end
    }
  end

  #
  # Helper methods so the tasks can stay clean
  #

  def get_chargify_subscriptions(page, direction = 'asc')
    if page == 0
      hash = { direction: direction }
    else
      hash = { page: page, direction: direction }
    end
    subs = Chargify::Subscription.find(:all, params: hash)

    if subs.count > 0
      subs
    else
      false
    end
  end

  def in_sync?(s_address, customer)
    if s_address.line_1 == customer.address and
        s_address.line_2.present? == customer.address_2.present? and
        s_address.city == customer.city and
        s_address.state == customer.state and
        s_address.zip == customer.zip and
        s_address.country == customer.country
      true
    else
      false
    end
  end

  def print_summary(total, a, b, color='white')
    puts total.to_s.white + " | #{a.id.to_s.ljust(7)} |" + " #{a.line_1} #{a.line_2}, #{a.city}, #{a.state}, #{a.zip}, #{a.country} - local".send(color)
    puts total.to_s.white + " | #{b.id} |" + " #{b.address} #{b.address_2}, #{b.city}, #{b.state}, #{b.zip}, #{b.country} - chargify".send(color)
  end

  # Get a page of Chargify customers
  # or return false.
  #
  def get_chargify_customers(page, direction="asc")
    hash = page == 0 ? { :direction => direction } : { :page => page, :direction => direction }
    chargifiers = Chargify::Customer.find(:all, :params => hash)
    if chargifiers.count > 0
      return chargifiers
    else
      return false
    end
  end

  def add_chargify_customer_account(user, customer)
    if user.chargify_customer_accounts.map(&:chargify_customer_id).include?(customer.id)
      puts "ChargifyCustomer Exists => customer_id: #{customer.id}"
    else
      chargify_customer = ChargifyCustomer.create!(chargify_customer_id: customer.id,
                                                   created_at:           customer.created_at)
      user.chargify_customer_accounts << chargify_customer
      puts "ChargifyCustomer Created => #{chargify_customer.id}".yellow
    end
  end

  def find_or_create_user(customer)
    # formatting
    #    puts "\n" + '-'*20 + " Processing Chargify Customer " + "-"*20 + "\n"

    if user = User.find_by_email(customer[:email])
      puts "User Exists => #{user.id}: #{user.email}\n".yellow
    else
      # TODO: confirmation_token
      password = Devise.friendly_token.first(8)
      full_name = "#{customer[:first_name]} #{customer[:last_name]}"
      user = User.new(
        email:                 customer[:email],
        full_name:             full_name,
        created_at:            customer[:created_at],
        password:              password,
        password_confirmation: password
      )

      if user.save
        puts "User Created => #{user.id}: #{user.email}\n".green
      else
        puts "Cannot create user #{customer[:id]} for ".red + user.email.magenta
        puts user.errors.full_messages.to_yaml.red
      end
    end
    return user
  end

  def find_or_create_subscription(user, customer, subscription)
    product_family_attrs = subscription.attributes[:product].attributes[:product_family].attributes
    #    puts "Processing subscription - #{product_family_attrs[:name].cyan} #{subscription.id.to_s.cyan}"

    # Skip if subscription exists
    if user.subscriptions and user.subscriptions.map(&:chargify_subscription_id).include?(subscription.id)
      puts "Subscription Exists => #{subscription.id}\n".yellow
      return nil
    end

    # Billing Address
    ba_hash = find_or_create_billing_address(subscription.credit_card.attributes)
    # Shipping Address
    sa_hash = find_or_create_shipping_address(customer.attributes)

    # create subscription with chargify_subscription_id and customer_id
    attrs = {
      created_at: subscription.created_at,
      chargify_subscription_id: subscription.id,
      customer_id: customer.id,
      cost: (subscription.product.price_in_cents / 100.0)
    }.merge(ba_hash).merge(sa_hash)

    begin
      sub = user.subscriptions.build(attrs)
    rescue => e
      puts subscription.credit_card.attributes.to_yaml.magenta
      puts customer.attributes.to_yaml.magenta
      pp attrs
      puts e.to_s.red
    end

    # add plan
    sub_attrs = subscription.attributes[:product].attributes
    sub.plan = Plan.find_by_name(sub_attrs[:handle])

    if sub.save
      user.save
      puts 'Subscription valid.'.green
    else
      puts 'Cannot create subscription for '.red + user.email.magenta
      puts sub.errors.full_messages.to_yaml.red
    end
    sub
  end

  # Returns Billing Address hash of attributes or id
  def find_or_create_billing_address(billing_address)
    billing_hash = {
      first_name: billing_address[:first_name],
      last_name:  billing_address[:last_name],
      line_1:     billing_address[:billing_address],
      line_2:     billing_address[:billing_address_2],
      city:       billing_address[:billing_city],
      state:      billing_address[:billing_state],
      zip:        billing_address[:billing_zip],
    }
    if (b_addr = BillingAddress.where(billing_hash).try(:first)).blank?
      ba_hash = { billing_address_attributes: billing_hash }
    else
      ba_hash = { billing_address_id: b_addr.id }
    end
    ba_hash
  end

  # Returns Shipping Address hash of attributes or id
  def find_or_create_shipping_address(shipping_address)
    shipping_hash = {
      first_name: shipping_address[:first_name],
      last_name:  shipping_address[:last_name],
      line_1:     shipping_address[:address],
      line_2:     shipping_address[:address_2],
      city:       shipping_address[:city],
      state:      shipping_address[:state],
      zip:        shipping_address[:zip]
    }
    if (s_addr = ShippingAddress.where(shipping_hash).try(:first)).blank?
      sa_hash = { shipping_address_attributes: shipping_hash }
    else
      sa_hash = { shipping_address_id: s_addr.id }
    end
    sa_hash
  end

  def print_stats(user, customer)
    puts "\nSubscription details for #{user.email.yellow}:"
    puts "     processed: #{customer.subscriptions.count.to_s.magenta}      total: #{user.subscriptions.count.to_s.cyan}\n\n"
  end

=begin
  desc 'combines csv and only users'
  task :migrate_users => :environment do
    puts Benchmark.measure {
      ActiveRecord::Base.transaction do
        csv_text = File.read("#{Rails.root}/customers_p.csv")
        csv = CSV.parse(csv_text, :headers => true)

        inserts = []
        count = 0
        csv.each do |customer|
          count += 1
          row = customer.to_hash
          full_name = "#{row['first_name']} #{row['last_name']}"
          confirmation_token = Devise.friendly_token.first(20)
          confirmation_sent_at = Time.now.utc.to_s
          password = Devise.friendly_token.first(8)
          begin
            user = User.create!(email:                 row['email'],
                                password:              password,
                                password_confirmation: password,
                                created_at:            row['created_at'],
                                full_name:             full_name)
            # confirmation_token:    confirmation_token,
            # confirmation_sent_at:  confirmation_sent_at)
            # puts user.email
          rescue => e
            puts "#{row['email']} - #{e}"
          end
          break if count == 400
        end
      end
    }
  end

  desc "Pulls all shirt sizes from Survey Monkey and updates subscriptions appropriately."
  task :add_shirt_sizes => :environment do
    postData = Net::HTTP.post_form(URI.parse('http://db-staging.herokuapp.com/'), {'postKey'=>'postValue'})
    puts postData.body

    User.all.each do |user|
      user.subscriptions.each do |subscription|
        #        subscription.shirt_size =
      end
    end
  end
=end

end
