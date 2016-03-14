require_relative "checkout_page_object"

class PetsCheckoutPage < CheckoutPage

  def initialize
    super
    @page_type = "pets_checkout"
    setup
  end

  def select_shirt_size(size)
    #stub
  end

  def select_pet_shirt_size(size)
    find('#select2-option_type_shirt-container').click
    wait_for_ajax
    find('.select2-results__option', :text => size).click
  end

  def select_pet_collar_size(size)
    find('#select2-option_type_collar-container').click
    wait_for_ajax
    find('.select2-results__option', :text => size).click
  end

  def select_human_wearable_size(size)
    find('#select2-option_type_human-wearable-container').click
    wait_for_ajax
    find('.select2-results__option', :text => size).click
  end

  def verify_confirmation_page
    assert_text('Thanks for subscribing to Loot Pets!')
  end
end
