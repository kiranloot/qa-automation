require_relative "mobile_checkout_page_object"

class LevelUpMobileCheckoutPage < MobileCheckoutPage

  def initialize
    super
    @page_type = "level_up_checkout"
    setup
  end

end
