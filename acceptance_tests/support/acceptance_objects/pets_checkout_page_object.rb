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
    fill_in('s2id_autogen1_search', :with => size)
    find('#s2id_autogen1_search').native.send_key(:enter)
  end

  def select_pet_collar_size(size)
    find(:id, 's2id_option_type_collar').click
    wait_for_ajax
    fill_in('s2id_autogen2_search', :with => size)
    find('#s2id_autogen2_search').native.send_key(:enter)
  end

  def select_shipping_state(state)
    find("#select2-chosen-5").click
    wait_for_ajax
    find("#s2id_autogen5_search").native.send_keys(state)
    find("#s2id_autogen5_search").native.send_keys(:enter)
  end

  def select_cc_exp_month(month)
    find(:id, "s2id_checkout_credit_card_expiration_date_2i").click
    find(:css, "#select2-results-6 > li > div", :text => month).click
  end

  def select_cc_exp_year(year)
    find(:id, "s2id_checkout_credit_card_expiration_date_1i").click
    find(:css, "#select2-results-7 > li > div", :text => year).click
  end

  def verify_confirmation_page
    assert_text('Thanks for subscribing to Loot Pets!')
  end
end
