require_relative "mobile_checkout_page_object"

class LevelUpMobileCheckoutPage < MobileCheckoutPage
  def select_shirt_size(size)
    #stub
  end

  def verify_confirmation_page
    wait_for_ajax
    find("#payment_completed-index")
  end

end
