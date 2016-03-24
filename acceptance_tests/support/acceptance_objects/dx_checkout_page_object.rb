require_relative "checkout_page_object"

class DXCheckoutPage < CheckoutPage

  def initialize
    super
    @page_type = "dx_checkout"
    setup
  end
end
