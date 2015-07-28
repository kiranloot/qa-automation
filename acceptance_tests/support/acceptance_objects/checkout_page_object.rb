require_relative "page_object"

class CheckoutPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "checkout"
    setup
  end

end