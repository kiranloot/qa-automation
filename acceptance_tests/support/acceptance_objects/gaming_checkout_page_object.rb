require_relative "checkout_page_object"

class GamingCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "gaming_checkout"
    setup
  end
end
