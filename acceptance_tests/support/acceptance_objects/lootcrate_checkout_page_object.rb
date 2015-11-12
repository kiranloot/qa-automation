require_relative "checkout_page_object"

class LootcrateCheckoutPage < CheckoutPage

  def initialze
    super
    @page_type = "lootcrate_checkout"
    setup
  end
end
