require_relative "subscribe_page_object"

class AnimeLandingPage < SubscribePage
include Capybara::DSL
include WaitForAjax

  def initialize
    super
    @page_type = "anime_landing"
    @tracking_script_lines << "lca.page('core_crates', 'show', '');"
    setup
    @plan_display_names = {
      'one' => 'Anime 1 Month Subscription',
      'three' => 'Anime 3 Month Subscription',
      'six' => 'Anime 6 Month Subscription',
      'twelve' => 'Anime 1 Year Subscription'
    }
  end

  def click_get_loot
    find('#alchemy_anime_header_carousel').find_link('GET LOOT ANIME').click
    $test.current_page = AnimeSubscribePage.new
    wait_for_ajax
  end

  def load_checkout_page_object
    $test.current_page = AnimeCheckoutPage.new
  end
end
