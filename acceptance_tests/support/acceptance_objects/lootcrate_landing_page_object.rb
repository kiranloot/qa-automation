require_relative "subscribe_page_object"

class LootcrateLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "lootcrate_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
    @plan_display_names = {
      'one' => '1 Month Plan Subscription',
      'three' => '3 Month Plan Subscription',
      'six' => '6 Month Plan Subscription',
      'twelve' => '12 Month Plan Subscription'
    }
  end

  def click_get_loot
    find(:css, "#alchemy_core_header_carousel").find_link("GET LOOT CRATE").click
    $test.current_page = LootcrateSubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    if ENV['DRIVER'] == 'appium'
      $test.current_page = LootcrateMobileCheckoutPage.new
    else
      $test.current_page = LootcrateCheckoutPage.new
    end
  end
end
