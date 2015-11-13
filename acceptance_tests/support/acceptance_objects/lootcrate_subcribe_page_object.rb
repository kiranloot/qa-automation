require_relative "page_object"

class LootcrateSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "lootcrate_subscribe"
    setup
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

  def click_thru_to_plan_selection
    #empty (no clickthrough necessary)
  end

  def load_checkout_page_object
    $test.current_page = LootcrateCheckoutPage.new
  end

  def update_target_plan(plan)
    plan_hash = {
      'one' => '1 Month Subscription',
      'three' => '3 Month Subscription',
      'six' => '1 Month Subscription',
      'twelve' => '1 Year Subscription',
    }
    $test.user.subscription_name = plan_hash[plan]
   end

end
