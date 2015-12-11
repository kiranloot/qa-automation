require_relative "checkout_page_object"

class PetsCheckoutPage < CheckoutPage

  def initialze
    super
    @page_type = "pets_checkout"
    setup
  end

  def select_shirt_size(size)
    #stub
  end

  def select_pet_shirt_size(size)
    find(:id, 's2id_option_type_shirt').click
    wait_for_ajax
    find('.select2-result-label', :text => size).click
  end

  def select_pet_collar_size(size)
    find(:id, 's2id_option_type_collar').click
    wait_for_ajax
    find('.select2-result-label', :text => size).click
  end

  def verify_confirmation_page
    assert_text('Thanks for subscribing to Loot Pets!')
  end
end
