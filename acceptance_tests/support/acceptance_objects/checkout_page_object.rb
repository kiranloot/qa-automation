require_relative "page_object"

class CheckoutPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "checkout"
    setup
  end

  def select_shirt_size(size)
    find("div#s2id_shirt_size > a").click
    wait_for_ajax
    find("input#s2id_autogen5_search").native.send_keys(size)
    find("input#s2id_autogen5_search").native.send_key(:enter)
  end

  def enter_first_name(name)
    fill_in("checkout_shipping_address_first_name", :with => name)
  end

  def enter_last_name(name)
    fill_in("checkout_shipping_address_last_name", :with => name)
  end

  def enter_shipping_address_line_1(street_1)
    fill_in("checkout_shipping_address_line_1", :with => street_1)
  end

  def enter_shipping_address_line_2(street_2)
    fill_in("checkout_shipping_address_line_2", :with => street_2)
  end
  
  def enter_shipping_city(city)
    fill_in("checkout_shipping_address_city", :with => city)
  end

  def select_shipping_state(state)
    find("#select2-chosen-7").click
    wait_for_ajax
    find("#s2id_autogen7_search").native.send_keys(state)
    find("#s2id_autogen7_search").native.send_keys(:enter)
  end

  def enter_shipping_zip_code(zip)
    fill_in("checkout_shipping_address_zip", :with => zip)
  end

  def enter_name_on_card(name)
    fill_in("checkout_billing_address_full_name", :with => name)
  end

  def enter_credit_card_number(number)
    fill_in("checkout_credit_card_number", :with => number)
  end

  def enter_cvv(cvv)
    fill_in("checkout_credit_card_cvv", :with => cvv)
  end

  def click_coupon_checkbox
    find(:id, "coupon-checkbox").click
  end

  def enter_coupon_code(code)
    fill_in("checkout_coupon_code", :with => code)
  end

  def validate_coupon_code
    find(:id, "validate-coupon").click
  end

  def click_subscribe
    find(:id, "checkout").click
  end

  def click_use_shipping_address_checkbox
    find(:id, "billing").click
  end

  def verify_confirmation_page
    #stub
    sleep(3)
  end
end
