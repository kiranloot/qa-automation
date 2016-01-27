require_relative "subscribe_page_object"

class PetsLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "pets_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
    @plan_display_names = {
      'one' => 'Pets 1 Month Subscription',
      'three' => 'Pets 3 Month Subscription',
      'six' => 'Pets 6 Month Subscription',
      'twelve' => 'Pets 1 Year Subscription'
    }
  end

  def click_get_loot
    find(:css, "#alchemy_pets_header_carousel").find_link("GET LOOT PETS").click
    $test.current_page = PetsSubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    $test.current_page = PetsCheckoutPage.new
  end
end
