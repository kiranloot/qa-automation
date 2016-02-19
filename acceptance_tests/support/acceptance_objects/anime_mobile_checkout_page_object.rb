require_relative "mobile_checkout_page_object"

class AnimeMobileCheckoutPage < MobileCheckoutPage

  def initialze
    super
    @page_type = "anime_checkout"
    setup
  end
end
