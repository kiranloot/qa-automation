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
      'one' => '1',
      'three' => '3',
      'six' => '6',
      'twelve' => '12'
    }
    setup
  end

  def select_shirt_size(size)
    find("#select2-option_type_shirt-container").click
    # wait_for_ajax
    find('.select2-search__field').send_keys(size)
    find(".select2-results__option", :text => size).click
  end

  def select_pet_shirt_size(size)
    #stub
  end

  def select_pet_collar_size(size)
    #stub
  end

  def select_human_wearable_size(size)
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
    $test.user.subscription.months = @plans[plan]
    $test.user.set_name
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

  def select_shipping_state(state, refresh_count=5)
    continue = false
    dropdown_button = find("span.select2-selection[aria-labelledby='select2-checkout_shipping_address_state-container']")
    refresh_count.times do
      dropdown_button.click
      find('.select2-search__field').send_keys(state)
      wait_for_ajax
      if find_all('.select2-results__option').any?
        continue = true
        break
      else
        # page.driver.browser.navigate.refresh
        dropdown_button.click
        sleep 1
      end
    end
    if continue
      # find('.select2-search__field').send_keys(state)
      find("#select2-checkout_shipping_address_state-results .select2-results__option", :text => state).click
    else
      raise "No states located in the state selection dropdown.\nAttempted reopening state selector menu #{refresh_count.to_s} time(s)."
    end
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
    wait_for_ajax
  end

  def enter_coupon_code(code)
    fill_in("checkout_coupon_code", :with => code)
    wait_for_ajax
  end

  def validate_coupon_code
    find("#validate-coupon").click
    wait_for_ajax
  end

  def click_subscribe
    find("#checkout").click
    wait_for_ajax
  end

  def assert_no_errors
    if current_url.include?('checkouts/new') || current_url.include?('/lp/')
      top_element = 
        self.class.to_s.include?('OnePageCheckout') ? '#one_page_checkout-new' : 'div.loot-container'
      possible_toast = find(top_element).first('div')
      if possible_toast.text.include?('prevented your checkout from')
        fields = find_all('.error')
        elements = []
        fields.each do |field|
          elements << field[:id]
        end
        raise """
        Checkout failed due to the following elements: #{elements.join(', ')} 
        NOTE: Elements part of recurly checkout may not be noted here.
        """
      end
    end
  end

  def click_use_shipping_address_checkbox
    find(".billing label[for=billing]").click
  end

  def click_legal_checkbox
    find("#terms-agree-checkbox").click
  end

  def verify_confirmation_page
    wait_for_ajax
    find('.loading')
    expect(current_url).to include('payment_completed')
    find(".confirmation-wrapper")
  end

  def select_shipping_country(country)
    find("div.checkout_shipping_address_country span.select2-selection").click
    wait_for_ajax
    find("li.select2-results__option", :text => country).click
    wait_for_ajax
    $test.user.verify_country_flag
  end

  def select_billing_country(country)
    find("div.checkout_billing_address_country #select2-checkout_billing_address_country-container").click
    wait_for_ajax
    find(".select2-results__option", :text => country).click
    wait_for_ajax
  end

  def submit_checkout_information(type, addbilling=false)
    user.subscription.billing_info.invalidate if type == 'invalid'
    click_captcha if intl_captcha?
    select_shirt_size(user.subscription.sizes[:shirt])
    #will only run on pets crate
    select_pet_shirt_size(user.subscription.sizes[:pet_shirt])
    select_pet_collar_size(user.subscription.sizes[:pet_collar])
    select_human_wearable_size(user.subscription.sizes[:unisex_shirt])
    #will only run for firefly
    select_unisex_shirt_size(user.subscription.sizes[:unisex_shirt])
    enter_first_name(user.first_name)
    enter_last_name(user.last_name)
    enter_shipping_address_line_1(user.ship_street)
    enter_shipping_city(user.ship_city)
    select_shipping_state(user.ship_state)
    enter_shipping_zip_code(user.ship_zip)
    enter_name_on_card(user.full_name)
    enter_credit_card_number(user.subscription.billing_info.cc_number)
    if @zip_tax_hash.keys.include? $test.user.ship_zip
      @tax_displayed = page.has_content? @zip_tax_hash[$test.user.ship_zip]
    end
    enter_cvv(user.subscription.billing_info.cvv)
    select_cc_exp_month(user.subscription.billing_info.exp_month)
    select_cc_exp_year(user.subscription.billing_info.exp_year)
    unless user.promo.nil?
      click_coupon_checkbox
      enter_coupon_code(user.promo.coupon_code)
      validate_coupon_code
      @discount_applied = page.has_content?("Valid coupon: save -$")
    end
    if addbilling
      click_use_shipping_address_checkbox
      unless find("div.checkout_billing_address_country .select2-selection__rendered").text == user.country
        select_billing_country(user.country)
      end
      enter_billing_address_1(user.billing_address.street)
      enter_billing_city(user.billing_address.city)
      enter_billing_zip(user.billing_address.zip)
      select_billing_state(user.billing_address.state)
    end
    click_legal_checkbox
    click_subscribe
    unless type == 'invalid'
      assert_no_errors
      verify_confirmation_page
    end
  end

  def intl_captcha?
      ["MX","CL","CO"].include? $test.user.country_code
  end

  def click_captcha
    within_frame("undefined"){
      find("span.recaptcha-checkbox").click
    }
  end

  def submit_credit_card_information_only(type)
    user.subscription.billing_info.invalidate if type == 'invalid'
    enter_name_on_card(user.full_name)
    enter_credit_card_number(user.subscription.billing_info.cc_number)
    enter_cvv(user.subscription.billing_info.cvv)
    select_cc_exp_month(user.subscription.billing_info.exp_month)
    select_cc_exp_year(user.subscription.billing_info.exp_year)
    click_legal_checkbox
    click_subscribe
    assert_no_errors unless type == 'invalid'
    verify_confirmation_page
  end

  def credit_card_fields_gone?
    expect(page).not_to have_selector("#checkout_credit_card_number")
    expect(page).not_to have_selector("#checkout_credit_card_cvv")
    expect(page).not_to have_selector("#select2-checkout_credit_card_expiration_date_2i-container")
    expect(page).not_to have_selector("#select2-checkout_credit_card_expiration_date_1i-container")
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

  private
  def sub_plans
    {
      'one' => 'one-month',
      'two' => 'two-month',
      'three' => 'three-month',
      'six' => 'six-month',
      'twelve' => 'twelve-month'
    }
  end

  def user
    $test.user
  end
end
