require_relative "subscribe_page_object"

class FireflyLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "firefly_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
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

  def click_get_loot
    find(:css, "#alchemy_firefly_header_carousel").find_link("GET FIREFLY LOOT").click
    $test.current_page = FireflySubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    $test.current_page = FireflyCheckoutPage.new
  end
end
