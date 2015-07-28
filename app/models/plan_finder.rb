module PlanFinder
  class << self
    def one_month_plan_for_country(country)
      Rails.cache.fetch("PlanFinder#one_month_plan_for_#{country}", expires_in: 12.hours) do
        by_country(country).where(period: 1).first
      end
    end

    def by_country(country)
      Rails.cache.fetch("PlanFinder#by_country - #{country}", expires_in: 12.hours) do
        plan_names = get_plan_names_for country
        Plan.where(name: plan_names)
      end
    end

    def upgradable_plans_for(subscription)
      current_plan = subscription.plan
      level_up_product?(current_plan) ? [] : find_upgradable_plans_for_core_product(current_plan)
    end

    private
      def level_up_product?(plan)
        plan.product_brand == 'Level Up'
      end

      def find_upgradable_plans_for_core_product(plan)
        plans_by_country = by_country plan.country
        period           = plan.period

        plans_by_country.where('period > ?', period)
      end

      def get_plan_names_for(country)
        Rails.cache.fetch("PlanFinder#get_plan_names_for_#{country}", expires_in: 12.hours) do

          case country
          when 'AU'
            [Settings.au_one_month_sub, Settings.au_three_month_sub, Settings.au_six_month_sub, Settings.au_twelve_month_sub]
          when 'CA'
            [Settings.ca_one_month_sub, Settings.ca_three_month_sub, Settings.ca_six_month_sub, Settings.ca_twelve_month_sub]
          when 'DE'
            [Settings.de_one_month_sub, Settings.de_three_month_sub, Settings.de_six_month_sub, Settings.de_twelve_month_sub]
          when 'DK'
            [Settings.dk_one_month_sub, Settings.dk_three_month_sub, Settings.dk_six_month_sub, Settings.dk_twelve_month_sub]
          when 'FI'
            [Settings.fi_one_month_sub, Settings.fi_three_month_sub, Settings.fi_six_month_sub, Settings.fi_twelve_month_sub]
          when 'FR'
            [Settings.fr_one_month_sub, Settings.fr_three_month_sub, Settings.fr_six_month_sub, Settings.fr_twelve_month_sub]
          when 'GB'
            [Settings.gb_one_month_sub, Settings.gb_three_month_sub, Settings.gb_six_month_sub, Settings.gb_twelve_month_sub]
          when 'IE'
            [Settings.ie_one_month_sub, Settings.ie_three_month_sub, Settings.ie_six_month_sub, Settings.ie_twelve_month_sub]
          when 'NL'
            [Settings.nl_one_month_sub, Settings.nl_three_month_sub, Settings.nl_six_month_sub, Settings.nl_twelve_month_sub]
          when 'NO'
            [Settings.no_one_month_sub, Settings.no_three_month_sub, Settings.no_six_month_sub, Settings.no_twelve_month_sub]
          when 'NZ'
            [Settings.nz_one_month_sub, Settings.nz_three_month_sub, Settings.nz_six_month_sub, Settings.nz_twelve_month_sub]
          when 'SE'
            [Settings.se_one_month_sub, Settings.se_three_month_sub, Settings.se_six_month_sub, Settings.se_twelve_month_sub]
          when 'US'
            [Settings.one_month_sub, Settings.three_month_sub, Settings.six_month_sub, Settings.twelve_month_sub]
          else
            [Settings.one_month_sub, Settings.three_month_sub, Settings.six_month_sub, Settings.twelve_month_sub]
          end
        end
      end
  end
end
