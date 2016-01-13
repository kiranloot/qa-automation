require_relative "subscribe_page_object"

class PetsSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "pets_subscribe"
    setup
    @plan_display_names = {
      'one' => 'Pets 1 Month Subscription',
      'three' => 'Pets 3 Month Subscription',
      'six' => 'Pets 6 Month Subscription',
      'twelve' => 'Pets 1 Year Subscription'
    }
  end

  def click_get_loot
    find(:css, "section.header").find_link("GET LOOT PETS").click
    wait_for_ajax
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def load_checkout_page_object
    $test.current_page = PetsCheckoutPage.new
  end
end
