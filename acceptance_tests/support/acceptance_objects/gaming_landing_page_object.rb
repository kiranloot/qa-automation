require_relative "subscribe_page_object"

class GamingLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "gaming_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
    @plan_display_names = {
      'one' => 'Gaming 1 Month Subscription',
      'three' => 'Gaming 3 Month Subscription',
      'six' => 'Gaming 6 Month Subscription',
      'twelve' => 'Gaming 1 Year Subscription'
    }
  end

  def click_get_loot
    find('#alchemy_gaming_header_carousel').find_link('LOOT NOW').click
    $test.current_page = GamingSubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    $test.current_page = GamingCheckoutPage.new
  end
end
