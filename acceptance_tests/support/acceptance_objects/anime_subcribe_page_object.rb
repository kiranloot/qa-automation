require_relative "subscribe_page_object"

class AnimeSubscribePage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "anime_subscribe"
    setup
    @plan_display_names = {
      'one' => 'Anime 1 Month Subscription',
      'three' => 'Anime 3 Month Subscription',
      'six' => 'Anime 6 Month Subscription',
      'twelve' => 'Anime 1 Year Subscription'
    }
  end

  def load_checkout_page_object
    $test.current_page = AnimeCheckoutPage.new
  end
end
