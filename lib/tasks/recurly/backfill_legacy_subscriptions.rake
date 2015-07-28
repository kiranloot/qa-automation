require './lib/recurly_adapter/subscription_backfiller'

namespace :recurly do
  task :create_subscription_backfill_jobs, [:filename] => [:environment] do |t, args|
    raise 'Filename must be passed in as argument' unless filename = args[:filename]
    # Store in our database
    puts "Started: #{DateTime.now}"
    RecurlyAdapter::SubscriptionBackfiller.csv_import(filename)
    puts "Completed: #{DateTime.now}"
  end

  task :process_subscription_backfill_jobs, [:filename] => [:environment] do |t, args|
    # Create subscription in recurly
    RecurlyAdapter::SubscriptionBackfiller.new.backfill
  end

  task :migrate_chargify_credits => :environment do
    puts "Started: #{DateTime.now}"
    RecurlyAdapter::CreditBackfiller.new.backfill
    puts "Completed: #{DateTime.now}"
  end

end
