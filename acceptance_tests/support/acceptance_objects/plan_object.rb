class Plan
require 'date'
require 'yaml'
attr_accessor :subscription_name, :subscription_display_name
def initialize(plan_months, date_subbed, upgrading, country: nil )
    @test_data = YAML.load(File.open($env_test_data_file_path))
    @plan_months = plan_months
    @country = country
    @subscription_name = get_subscription_name(@plan_months, @country)
    @subscription_display_name = get_subscription_display_name(@plan_months)
    @date_subbed = date_subbed
    @upgrading_to_this = upgrading 
    @total_cost = get_total_cost(@plan_months, @country)
    @crates_remaining = get_crates_remaining
    @unit_cost = get_itemized_cost
    @us_plans = @test_data['us_plans']
  end

  def get_total_cost(months, country)
    if !country
      return @test_data['plan_cost'][months]
    else
      return @test_data['international_plan_cost'][months]
    end
  end

  def get_crates_remaining
    today = Date.today
    this_month_remains = true
    expired = false
    if today.day >= 20
      this_month_remains = false
    end
    
    if (@date_subbed >> @plan_months).month < today.month
      expired = true
    end
  end
  
  def get_itemized_cost

  end

  def get_subscription_name(month_int, country)
    if country
      return @test_data['international_plans'][country][month_int]
    else
      return @test_data['us_plans'][month_int]
    end
  end

  def get_subscription_display_name(month_int)
    return @test_data['us_display_plans'][month_int] 
  end
end
