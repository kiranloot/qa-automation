require_relative "checkout_page_object"

class FireflyCheckoutPage < CheckoutPage

  def initialze
    super
    @page_type = "firefly_checkout"
    setup
  end

  def verify_confirmation_page
    page.has_content?("FIREFLY® CARGO CRATE ORDER CONFIRMED!")
  end

  def select_shirt_size(size)
    #stub
  end

  def select_unisex_shirt_size(size)
    find("div#s2id_option_type_shirt > a").click
    wait_for_ajax
    find(".select2-result-label", :text => size).click
  end
end
