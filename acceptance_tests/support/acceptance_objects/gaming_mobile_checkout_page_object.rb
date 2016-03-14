require_relative "mobile_checkout_page_object"

class GamingMobileCheckoutPage < MobileCheckoutPage

  def initialize
    super
    @page_type = "gaming_checkout"
    setup
  end
end
