require_relative "subscribe_page_object"

class FireflySubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "firefly_subscribe"
    setup
    @plans = {
      'two' => 'two-month',
      'six' => 'six-month',
      'twelve' => 'twelve-month'
    }
    @plan_display_names = {
      'two' => '2 Month Plan Subscription',
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
      $test.current_page = FireflyMobileCheckoutPage.new
    else
      $test.current_page = FireflyCheckoutPage.new
    end
  end
end
