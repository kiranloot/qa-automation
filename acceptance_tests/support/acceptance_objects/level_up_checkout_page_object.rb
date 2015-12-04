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

  #shipping_state_has a different_dropdown
  def select_shipping_state(state)
    find("#select2-chosen-6").click
    wait_for_ajax
    find("#s2id_autogen6_search").native.send_keys(state)
    find("#s2id_autogen6_search").native.send_keys(:enter)
  end

  def select_cc_exp_month(month)
    find(:id, "s2id_checkout_credit_card_expiration_date_2i").click
    find(:css, "#select2-results-7 > li > div", :text => month).click
  end

  def select_cc_exp_year(year)
    find(:id, "s2id_checkout_credit_card_expiration_date_1i").click
    find(:css, "#select2-results-8 > li > div", :text => year).click
  end
end
