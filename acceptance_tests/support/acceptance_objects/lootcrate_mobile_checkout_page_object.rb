require_relative "mobile_checkout_page_object"

class LootcrateMobileCheckoutPage < MobileCheckoutPage

  def initialze
    super
    @page_type = "lootcrate_checkout"
    setup
  end

end
