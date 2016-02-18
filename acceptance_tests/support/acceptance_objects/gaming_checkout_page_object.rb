require_relative "checkout_page_object"

class GamingCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "gaming_checkout"
    setup
  end

  def verify_confirmation_page
    assert_text("MISSION ACCOMPLISHED!")
  end
end
