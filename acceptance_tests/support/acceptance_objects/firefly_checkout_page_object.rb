require_relative "checkout_page_object"

class FireflyCheckoutPage < CheckoutPage

  def initialize
    super
    @page_type = "firefly_checkout"
    setup
  end

  def verify_confirmation_page
    assert_text("FIREFLY™ CARGO CRATE ORDER CONFIRMED!")
  end

  def select_shirt_size(size)
    #stub
  end

  def select_unisex_shirt_size(size)
    find("#select2-option_type_shirt-container").click
    wait_for_ajax
    find(".select2-results__option", :text => size).click
  end
end
