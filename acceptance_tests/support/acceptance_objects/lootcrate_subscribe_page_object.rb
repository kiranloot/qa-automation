require_relative "subscribe_page_object"

class LootcrateSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "lootcrate_subscribe"
    setup
    @plan_display_names = {
      'one' => '1 Month Plan Subscription',
      'three' => '3 Month Plan Subscription',
      'six' => '6 Month Plan Subscription',
      'twelve' => '12 Month Plan Subscription'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def load_checkout_page_object
    if ENV['DRIVER'] == 'appium'
      $test.current_page = LootcrateMobileCheckoutPage.new
    else
      $test.current_page = LootcrateCheckoutPage.new
    end
  end
end
