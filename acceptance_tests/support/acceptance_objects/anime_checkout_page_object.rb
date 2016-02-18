require_relative "checkout_page_object"

class AnimeCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "anime_checkout"
    setup
  end

  def verify_confirmation_page
    assert_text("Thanks for subscribing to Loot Anime!")
  end
end
