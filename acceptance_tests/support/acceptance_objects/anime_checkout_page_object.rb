require_relative "checkout_page_object"

class AnimeCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "anime_checkout"
    setup
  end

  def verify_confirmation_page
    page.has_content?("Thanks for subscribing to Loot Anime!")
  end
end
