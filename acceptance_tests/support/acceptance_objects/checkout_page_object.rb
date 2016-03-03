require_relative "page_object"

class CheckoutPage < Page
include Capybara::DSL

  def initialize
    super
    @page_type = "checkout"
    @discount_applied = nil
    @tax_displayed = nil
    @zip_tax_hash = YAML.load(File.open("acceptance_tests/support/tax_amounts.yml"))
    @plans = {
      'one' => '1 Month',
      'three' => '3 Month',
      'six' => '6 Month',
      'twelve' => '12 Month'
    }
    setup
  end

  def select_shirt_size(size)
    find("#select2-option_type_shirt-container").click
    wait_for_ajax
    find(".select2-results__option", :text => size).click
  end

  def select_pet_shirt_size(size)
    #stub
  end

  def select_pet_collar_size(size)
    #stub
  end

  def select_unisex_shirt_size(size)
    #stub
  end

  def select_upsell_plan(plan)
    find(".checkout-upsell [role=combobox]").click
    wait_for_ajax
    find("li.select2-results__option", :text => @plans[plan]).click
    wait_for_ajax
    $test.user.subscription_name = "#{@plans[plan]} Plan Subscription"
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
    find("span.select2-selection[aria-labelledby='select2-checkout_shipping_address_state-container']").click
    wait_for_ajax
    find(".select2-results__option", :text => state).click
  end

  def enter_shipping_zip_code(zip)
    fill_in("checkout_shipping_address_zip", :with => zip)
  end

  def enter_billing_address_1(address)
    fill_in("checkout_billing_address_line_1", :with => address)
  end

  def enter_billing_city(city)
    fill_in("checkout_billing_address_city", :with => city)
  end

  def enter_billing_zip(zip)
    fill_in("checkout_billing_address_zip", :with => zip)
  end

  def select_billing_state(state)
    find("span#select2-checkout_billing_address_state-container").click
    wait_for_ajax
    find(".select2-results__option", :text => state).click
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
    find("#select2-checkout_credit_card_expiration_date_2i-container").click
    find(".select2-results__option", :text => month).click
  end

  def select_cc_exp_year(year)
    find("#select2-checkout_credit_card_expiration_date_1i-container").click
    find(".select2-results__option", :text => year).click
  end

  def click_coupon_checkbox
    find("div.coupon-field-show-checkbox").click
  end

  def enter_coupon_code(code)
    fill_in("checkout_coupon_code", :with => code)
  end

  def validate_coupon_code
    find("#validate-coupon").click
  end

  def click_subscribe
    find("#checkout").click
  end

  def click_use_shipping_address_checkbox
    find(".billing label[for=billing]").click
  end

  def click_legal_checkbox
    find("#terms-agree-checkbox").click
  end

  def verify_confirmation_page
    #stub
    wait_for_ajax
    sleep(10)
  end

  def set_ship_to_country(country)
    find("div.checkout_shipping_address_country span.select2-selection").click
    wait_for_ajax
    find("li.select2-results__option", :text => country).click
    wait_for_ajax
    # expect(find('.currentflag img')[:src]).to include("flags/#{$test.user.country_code.downcase}_flag-")
    # find('.currentflag img', :src => "flags/#{$test.user.country_code.downcase}_flag-")
    find(:xpath, "//img[contains(@src, '#{$test.user.country_code.downcase}_flag-')]")
  end

  def submit_checkout_information(user, type, addbilling=false)
    select_shirt_size(user.shirt_size)
    #will only run on pets crate
    select_pet_shirt_size(user.pet_shirt_size)
    select_pet_collar_size(user.pet_collar_size)
    #will only run for firefly
    select_unisex_shirt_size(user.unisex_shirt_size)
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
    unless user.promo.nil?
      click_coupon_checkbox
      enter_coupon_code(user.promo.coupon_code)
      validate_coupon_code
      @discount_applied = page.has_content?("Valid coupon: save $")
    end
    if @zip_tax_hash.keys.include? $test.user.ship_zip
      @tax_displayed = page.has_content? @zip_tax_hash[$test.user.ship_zip]
    end
    enter_cvv(user.cvv)
    select_cc_exp_month(user.cc_exp_month)
    select_cc_exp_year(user.cc_exp_year)

    if addbilling
      click_use_shipping_address_checkbox
      unless find("div.checkout_billing_address_country .select2-selection__rendered").text == user.first_name
        find("div.checkout_billing_address_country #select2-checkout_billing_address_country-container").click
        wait_for_ajax
        find(".select2-results__option", :text => user.first_name).click
        wait_for_ajax
      end
      enter_billing_address_1(user.billing_address.street)
      enter_billing_city(user.billing_address.city)
      enter_billing_zip(user.billing_address.zip)
      select_billing_state(user.billing_address.state)
    end

    click_legal_checkbox
    click_subscribe
    unless type == 'invalid'
      verify_confirmation_page
    end
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

  def tax_displayed?
    expect(@tax_displayed).to be_truthy
  end

  def shirt_variant_soldout?(variant)
    find("#select2-option_type_shirt-container").click
    expect(find("li.select2-results__option[aria-disabled='true']", :text => variant)).to be_truthy
  end
end
