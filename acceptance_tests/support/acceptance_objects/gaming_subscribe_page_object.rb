require_relative "subscribe_page_object"

class GamingSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "gaming_subscribe"
    setup
    @plan_display_names = {
      'one' => 'Gaming 1 Month Plan Subscription',
      'three' => 'Gaming 3 Month Plan Subscription',
      'six' => 'Gaming 6 Month Plan Subscription',
      'twelve' => 'Gaming 1 Year Plan Subscription'
    }
  end

  def load_checkout_page_object
    $test.current_page = GamingCheckoutPage.new
  end
end
