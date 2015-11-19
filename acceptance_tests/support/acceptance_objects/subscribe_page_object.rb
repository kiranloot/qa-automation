require_relative "page_object"

class SubscribePage < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "subscribe"
    setup
    @cc_fail_message = "There was an error validating your request."
    @plans = {
      'one' => 'one-month',
      'three' => 'three-month',
      'six' => 'six-month',
      'twelve' => 'twelve-month'
    }
    @plan_display_names = {
      'one' => '1 Month Subscription',
      'three' => '3 Month Subscription',
      'six' => '1 Month Subscription',
      'twelve' => '1 Year Subscription',
    }
  end

  def visit_page
    visit @base_url 
    $test.current_page = self
  end

  def subscription_failed?(fault)
    case fault
    when "invalid credit card"
      assert_text(@cc_fail_message)
    end

    #This was failing in master.  Commenting out for now.
    #if page.has_content?("Error prevented")
    #  page.find('body > div.blurred > div.alert-bg > div > div > div > a').click
    #end
  end

  def select_plan(plan)
    if plan == 'random'
      rand_key = @plans.keys[rand(@plans.keys.size)]
      target = @plans[rand_key]
      plan = rand_key
    else
      target = @plans[plan]
    end
    find(:id, target).click
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
