require_relative "checkout_page_object"

class LevelUpCheckoutPage < CheckoutPage
include Capybara::DSL

  def initialize
    super
    @page_type = "level_up_checkout"
  end

  def select_shirt_size(size)
    #stubbed out (no shirt size during checkout)
  end

  def verify_confirmation_page
    Capybara.default_max_wait_time = 30
    wait_for_ajax
    find("#payment_completed-index")
    Capybara.default_max_wait_time = 15
  end
end
