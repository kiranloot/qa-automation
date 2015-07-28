namespace :recurly do
  desc 'create plans in recurly'
  task :create_plans => :environment do
    us_plans = ['1-month-subscription',
                '3-month-subscription',
                '6-month-subscription',
                '12-month-subscription',
                'lc-lu01-01-us',
                'lc-lu01-03-us',
                'lc-lu01-06-us',
                'lc-lu01-12-us',
                'lc-lu02-01-us',
                'lc-lu02-03-us',
                'lc-lu02-06-us',
                'lc-lu02-12-us',
                'lc-lu03-01-us',
                'lc-lu03-03-us',
                'lc-lu03-06-us',
                'lc-lu03-12-us'
               ]

    Plan.all.each do |plan|
      # Titleize name
      name = "#{plan.name.gsub('-', ' ').titleize}"
      begin
        # is it already in recurly?
        Recurly::Plan.find(plan.name)
      rescue Recurly::Resource::NotFound
        # Create plan if not in recurly
        tax_exempt = !us_plans.include?(plan.name)
        begin
          Recurly::Plan.create!(
            plan_code:             plan.name,
            name:                  name,
            unit_amount_in_cents:  (plan.cost*100).round,
            plan_interval_length:  plan.period,
            tax_exempt:            tax_exempt
          )
          puts "#{plan.name} - #{name} - #{(plan.cost*100).round} - #{plan.period}"
        rescue
          puts "!!! #{plan.name} - failed"
        end
      end
    end
  end

  task :create_legacy_plans => :environment do
    legacy_plans = [
      {name: '1-month-subscription-v1', cost_in_cents: 19_37, period: 1},
      {name: '3-month-subscription-v1', cost_in_cents: 55_11, period: 3},
      {name: '6-month-subscription-v1', cost_in_cents: 105_99, period: 6}
    ]
    legacy_plans.each do |plan|
      begin
        # Do nothing if plan is already in Recurly
        Recurly::Plan.find(plan[:name])
      rescue Recurly::Resource::NotFound
        # Create plan if not in recurly
        name = "#{plan[:name].gsub('-', ' ').titleize}"
        begin
          Recurly::Plan.create!(
            plan_code:             plan[:name],
            name:                  name,
            unit_amount_in_cents:  (plan[:cost_in_cents]).to_i,
            plan_interval_length:  plan[:period],
            tax_exempt:            false
          )
          puts "#{plan[:name]} - #{name} - #{plan[:cost_in_cents].to_i} - #{plan[:period]}"
        rescue
          puts "!!! #{plan[:name]} - failed"
        end
      end
    end
  end
end
