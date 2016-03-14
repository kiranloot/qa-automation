require_relative "subscribe_page_object"

class GamingSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "gaming_subscribe"
    setup
    @plan_display_names = {
      'one' => 'Gaming 1 Month Subscription',
      'three' => 'Gaming 3 Month Subscription',
      'six' => 'Gaming 6 Month Subscription',
      'twelve' => 'Gaming 1 Year Subscription'
    }
  end

  def load_checkout_page_object
    if ENV['DRIVER'] == 'appium'
      $test.current_page = GamingMobileCheckoutPage.new
    else
      $test.current_page = GamingCheckoutPage.new
    end
  end
end
