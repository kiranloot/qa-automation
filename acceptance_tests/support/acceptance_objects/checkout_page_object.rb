require_relative "page_object"

class CheckoutPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "checkout"
    @discount_applied = nil
    setup
  end

  def select_shirt_size(size)
    find("div#s2id_option_type_shirt > a").click
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

  def select_cc_exp_month(month)
    find(:id, "s2id_checkout_credit_card_expiration_date_2i").click
    find(:css, "#select2-results-8 > li > div", :text => month).click
  end

  def select_cc_exp_year(year)
    find(:id, "s2id_checkout_credit_card_expiration_date_1i").click
    find(:css, "#select2-results-9 > li > div", :text => year).click
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

  def click_legal_checkbox
    find(:id, "terms-agree-checkbox").click
  end

  def verify_confirmation_page
    #stub
    sleep(5)
  end

  def submit_checkout_information(user, type)
    select_shirt_size(user.shirt_size)
    enter_first_name(user.first_name)
    enter_last_name(user.last_name)
    enter_shipping_address_line_1(user.ship_street)
    enter_shipping_city(user.ship_city)
    select_shipping_state(user.ship_state)
    enter_shipping_zip_code(user.ship_zip)
    enter_name_on_card(user.full_name)
    if type == 'invalid'
      enter_credit_card_number(user.cc_invalid)
    else
      enter_credit_card_number(user.cc)
    end
    unless user.coupon_code.nil?
      click_coupon_checkbox
      enter_coupon_code(user.coupon_code) 
      validate_coupon_code
      @discount_applied = page.has_content?("Valid coupon: save $")
    end
    enter_cvv(user.cvv)
    select_cc_exp_month(user.cc_exp_month)
    select_cc_exp_year(user.cc_exp_year)
    click_legal_checkbox
    click_subscribe
    verify_confirmation_page
  end

  def submit_credit_card_information_only(user, type)
    enter_name_on_card(user.full_name)
    if type == 'invalid'
      enter_credit_card_number(user.cc_invalid)
    else
      enter_credit_card_number(user.cc)
    end
    enter_cvv(user.cvv)
    select_cc_exp_month(user.cc_exp_month)
    select_cc_exp_year(user.cc_exp_year)
    click_legal_checkbox
    click_subscribe
    verify_confirmation_page
  end

  def discount_applied?
    expect(@discount_applied).to be_truthy
  end

  def subscription_failed?(fault)
    case fault
    when "invalid credit card"
      assert_text("There was an error validating your request.")
    end
  end
end
