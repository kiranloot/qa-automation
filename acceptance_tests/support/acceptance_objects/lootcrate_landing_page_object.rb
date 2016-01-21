require_relative "subscribe_page_object"

class LootcrateLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "lootcrate_landing"
    setup
    @plan_display_names = {
      'one' => '1 Month Subscription',
      'three' => '3 Month Subscription',
      'six' => '6 Month Subscription',
      'twelve' => '12 Month Subscription'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def click_get_loot
    find(:css, "section.header").find_link("GET LOOT CRATE").click
    $test.current_page = LootcrateSubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    $test.current_page = LootcrateCheckoutPage.new
  end
end
