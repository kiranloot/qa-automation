require_relative "page_object"

class SubscribePage < Page
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "subscribe"
    setup
    @cc_fail_message = "There was an error validating your request."
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

  def select_plan(months)
    choices = ['one-month', 'three-month', 'six-month', 'twelve-month']
    months = months.strip.downcase
    if months == "one"
      target = 'one-month'
    elsif months == "three"
      target = 'three-month'
    elsif months == "six"
      target = 'six-month'
    elsif months == "twelve"
      target  = 'twelve-month'
    elsif months == 'random'
      target = choices[rand(choices.size)]
      months = target[/[^-]+/]
    else
      puts "Invalid plan selection: " +  months
    end
    click_link(target)
    wait_for_ajax
  end

  def verify_plan_prices(domain)
    if domain == 'international'
      for k, v in $test.test_data['international_plan_cost']
        assert_text("Total Price: $" + v.to_s)
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
