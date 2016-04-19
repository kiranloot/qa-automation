require_relative "core_page_checkout_object"

class AnimeOnePageCheckout < OnePageCheckout
include Capybara::DSL

  def initialize
    super
    @page_type = "anime"
    $test.user.crate_type = "Anime"
    setup
  end

  private
  def plan_display_names
    {
      'one' => 'Anime 1 Month Subscription',
      'three' => 'Anime 3 Month Subscription',
      'six' => 'Anime 6 Month Subscription',
      'twelve' => 'Anime 1 Year Subscription'
    }
  end
end
