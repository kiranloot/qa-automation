require_relative "core_page_checkout_object"

class GamingOnePageCheckout < OnePageCheckout
include Capybara::DSL

  def initialize
    super
    @page_type = "gaming"
    $test.user.crate_type = "Gaming"
    setup
  end

  private
  def plan_display_names
    {
      'one' => 'Gaming 1 Month Subscription',
      'three' => 'Gaming 3 Month Subscription',
      'six' => 'Gaming 6 Month Subscription',
      'twelve' => 'Gaming 1 Year Subscription'
    }
  end
end
