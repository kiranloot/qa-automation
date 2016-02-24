require_relative "subscribe_page_object"

class PetsSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "pets_subscribe"
    setup
    @plan_display_names = {
      'one' => 'Pets 1 Month Plan Subscription',
      'three' => 'Pets 3 Month Plan Subscription',
      'six' => 'Pets 6 Month Plan Subscription',
      'twelve' => 'Pets 1 Year Plan Subscription'
    }
  end

  def visit_page
    visit @base_url
    $test.current_page = self
  end

  def load_checkout_page_object
    if ENV["DRIVER"] == 'appium'
      $test.current_page = PetsMobileCheckoutPage.new
    else
      $test.current_page = PetsCheckoutPage.new
    end
  end
end
