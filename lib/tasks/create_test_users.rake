namespace :create_test_users do
  desc 'User with one active  subscription'
  task with_one_active_subscription: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.start

    user = creator.user

    puts 'User with one active subscription'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with one active subscription on a trial period'
  task :with_one_active_subscription_on_trial, [:plan_name, :coupon_code] => :environment do |t, args|
    puts 'Starting...'

    creator = TestUser.new(plan_name: args.plan_name, coupon_code: args.coupon_code)
    creator.create_existing_subscription

    user = creator.user

    puts 'User with one active subscription'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with one canceled subscription'
  task with_one_canceled_subscription: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.start

    creator.cancel_subscription

    user = creator.user

    puts 'User with one canceled  subscription'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with one active and one canceled  subscription'
  task with_one_active_and_one_canceled_subscription: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.start

    creator.cancel_subscription

    creator.start

    user = creator.user

    puts 'User with one active and one canceled  subscription'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with one active  subscription with tracking for current crate month.'
  task with_one_active_subscription_with_tracking: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.start

    creator.create_subscription_unit

    user = creator.user

    puts 'User with one active  subscription with tracking for current crate month.'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with one active  subscription with store credits'
  task with_one_active_subscription_with_store_credits: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.start

    creator.create_store_credit

    user = creator.user

    puts 'User with one active  subscription with store credits'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'User with no subscriptions'
  task with_no_subscriptions: :environment do
    puts 'Starting...'

    creator = TestUser.new
    creator.create_user

    user = creator.user

    puts 'User no subscriptions'
    puts "Email: #{user.email}\nPassword: password"
  end

  desc 'List of available commands'
  task help: :environment do
    puts 'User with one active  subscription'
    puts ':with_one_active_subscription'
    puts ''

    puts 'User with one active  subscription on trial period'
    puts ':with_one_active_subscription_on_trial'
    puts ''

    puts 'User with one canceled  subscription'
    puts ':with_one_canceled_subscription'
    puts ''

    puts 'User with one active and one canceled  subscription'
    puts ':with_one_active_and_one_canceled_subscription'
    puts ''

    puts 'User with one active  subscription with tracking for current crate month.'
    puts ':with_one_active_subscription_with_tracking'
    puts ''

    puts 'User with one active  subscription with store credits'
    puts ':with_one_active_subscription_with_store_credits'
    puts ''

    puts 'User with no subscriptions'
    puts ':with_no_subscriptions'
    puts ''
  end
end
