require_relative "checkout_page_object"

class LevelUpCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "level_up_checkout"
    setup
  end
end
