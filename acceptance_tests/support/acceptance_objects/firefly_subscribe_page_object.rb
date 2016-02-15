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
      'two' => '2 Month Subscription',
      'six' => '6 Month Subscription',
      'twelve' => '12 Month Subscription'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def load_checkout_page_object
    $test.current_page = FireflyCheckoutPage.new
  end
end
