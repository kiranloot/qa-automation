namespace :plans do
  task :create_legacy_plans => :environment do
    Plan.where(name: '1-month-subscription-v1').first_or_create.update_attributes({cost: 19.37, period: 1, shipping_and_handling: 6.0, savings_copy: "Cancel Anytime"})
    Plan.where(name: '3-month-subscription-v1').first_or_create.update_attributes({cost: 55.11, period: 3, shipping_and_handling: 6.0, savings_copy: "You Save $2.10!"})
    Plan.where(name: '6-month-subscription-v1').first_or_create.update_attributes({cost: 105.99, period: 6, shipping_and_handling: 6.0, savings_copy: "You Save $6!"})
  end

  namespace :legacy do
    def get_plan_code(subscription)
      if subscription.pending_subscription
        subscription.pending_subscription.plan_code
      else
        subscription.plan_code
      end
    end

    def get_plan(plan_code)
      Plan.where(name: plan_code).first or
        raise "plan:find:failure #{plan_code}"
    end

    def get_subscription(recurly_subscription)
      uuid = recurly_subscription.uuid
      Subscription.where(recurly_subscription_id: uuid).first or
        raise "subscription:find:failure #{uuid}"
    end

    def update_subscription(subscription, plan)
      if subscription.update_attributes(plan_id: plan.id)
        puts "subscription:update:success #{subscription.id} #{plan.name}"
      else
        raise "subscription:update:failure #{subscription.id} #{plan.name}"
      end
    end

    def fix_subscription(recurly_subscription, target_plan)
      subscription = get_subscription(recurly_subscription)
      plan = get_plan(target_plan)
      update_subscription(subscription, plan)
    end

    def fix_legacy_plans(legacy_plans)
      Recurly::Subscription.find_each(200) do |subscription|
        begin
          plan_code = get_plan_code(subscription)
          next unless legacy_plans.include?(plan_code)
          fix_subscription(subscription, plan_code)
        rescue Exception => err
          puts err
        end
      end
    end

    task :sync_with_recurly => :environment do
      legacy_plans = [
        "1-month-subscription-v1",
        "3-month-subscription-v1",
        "6-month-subscription-v1",
        "12-month-subscription-v1"
      ]
      fix_legacy_plans(legacy_plans)
    end
  end
end
