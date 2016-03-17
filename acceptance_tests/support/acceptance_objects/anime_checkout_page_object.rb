require_relative "checkout_page_object"

class AnimeCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "anime_checkout"
    setup
  end
end
