require_relative "page_object"

class SubscribePage < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "subscribe"
    setup
    @plans = {
      'one' => 'one-month',
      'three' => 'three-month',
      'six' => 'six-month',
      'twelve' => 'twelve-month'
    }
  end

  def visit_page
    visit @base_url 
    $test.current_page = self
  end

  def subscription_failed?(fault)
    case fault
    when "invalid credit card"
      assert_text("There was an error validating your request.")
    end
  end

  def click_get_loot
    #stub
  end

  def select_plan(plan)
    click_get_loot
    if plan == 'random'
      rand_key = @plans.keys.sample
      target = @plans[rand_key]
      plan = rand_key
    else
      target = @plans[plan]
    end
    find(:css, "##{target}").click
    wait_for_ajax
    update_target_plan(plan)
    load_checkout_page_object
  end

  def update_target_plan(plan)
    $test.user.subscription_name = @plan_display_names[plan]
  end

  def load_checkout_page_object
    #stub = to be overridden by children
  end

  def verify_plan_prices(domain)
    if domain == 'international'
      for k, v in $test.test_data['international_plan_cost']
        assert_text(v.to_s)
      end
    elsif domain == 'domestic'
      for k, v in $test.test_data['international_plan_cost']
        assert_text("Total Price: $" + v.to_s)
      end
   else
     puts "ERROR: Unknown Shipping Domain"
   end
  end
 
  def proration_applied?(old_plan, new_plan, date_subscribed)
    old = Plan.new(old_plan, date_subscribed, false)
    new = Plan.new(new_plan, date_subscribed, true)
  end

end
