namespace :chargify do
  desc 'find missing subscriptions'
  task :list_missing_subscriptions, [:page] => [:environment] do |t, args|
    args.with_defaults(:page => 0)
    page = args[:page].to_i
    missing = []
    while subscriptions = get_chargify_subscriptions(page)
      page += 1
      puts "\nPage #{page}"

      for subscription in subscriptions
        next unless ['active', 'past_due'].include?(subscription.state)

        if Subscription.find_by_chargify_subscription_id(subscription.id)
          print '.'.green
        else
          puts "\nsubscription #{subscription.id} missing".red
          missing << subscription.id
        end
      end
    end
    puts 'Missing'
    puts missing.inspect
    puts 'Task Complete'
  end

  desc 'find missing customers'
  task :list_missing_customers, [:page] => [:environment] do |t, args|
    args.with_defaults(:page => 0)
    page = args[:page].to_i
    missingFromSubscriptions = []
    missingFromChargifyCustomers = []
    while customers = get_chargify_customers(page)
      page += 1
      puts "\nPage #{page}"

      for customer in customers
        if Subscription.find_by_customer_id(customer.id)
          print ".".green
        else
          puts "\ncustomer #{customer.id} missing (from Subscriptions)".red
          missingFromSubscriptions << customer.id
        end

        if ChargifyCustomer.find_by_chargify_customer_id(customer.id)
          print '.'.green
        else
          puts "\ncustomer #{customer.id} missing (from Chargify_Customers)".red
          missingFromChargifyCustomers << customer.id
        end
      end

    end
    puts '\nmissingFromSubscriptions:'
    puts missingFromSubscriptions.inspect
    puts 'missingFromChargifyCustomers:'
    puts missingFromChargifyCustomers.inspect
    puts 'Task Complete'
  end

  desc 'Sync subscriptions'
  task :sync_subscriptions, [:start, :batch_size] => [:environment] do |t, args|
    args.with_defaults(start: 0, batch_size: 1000)
    start = args[:start].to_i
    batch_size = args[:batch_size].to_i
    @num_success = 0
    @num_failed = 0

    @logger = Logger.new('subscription_syncer')
    @logger.level = Logger::INFO

    threads = []
    Subscription.find_each(start: start, batch_size: batch_size) do |subscription|
      threads << Thread.new do
        begin
          results = ::SubscriptionSyncer.new(subscription).sync
          if results
            @num_success += 1
            @logger.info "Subscription: #{subscription.id} updated"
          else
            @num_failed += 1
            @logger.info "!!! Subscription: #{subscription.id} failed"
          end
        rescue => e
          @logger.info "problem with subscription id ##{subscription.id}: #{e.message}"
        end
      end
    end
    threads.map(&:join)

    puts "Number of subscription update success: #{@num_success}"
    puts "Number of subscription update failed: #{@num_failed}"

  end

  def get_chargify_subscriptions(page, direction = 'asc')
    if page == 0
      hash = { direction: direction }
    else
      hash = { page: page, direction: direction }
    end

    subs = Chargify::Subscription.find(:all, :params => hash)
    subs.count > 0 ? subs : false
  end

  def get_chargify_customers(page, direction = 'asc')
    if page == 0
      hash = { direction: direction }
    else
      hash = { page: page, direction: direction }
    end

    customers = Chargify::Customer.find(:all, :params => hash)
    customers.count > 0 ? customers : false
  end
end
