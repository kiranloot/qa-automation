require_relative "mobile_checkout_page_object"

class FireflyMobileCheckoutPage < MobileCheckoutPage

  def initialize
    super
    @page_type = "firefly_checkout"
    setup
  end

  def select_shirt_size(size)
    #stub
  end

  def select_unisex_shirt_size(size)
    select "#{size}", :from => "option_type_shirt"
  end

end
