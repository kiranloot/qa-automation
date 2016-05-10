require_relative "page_object"
require_relative "wait_module"
require "capybara/cucumber"
require "pry"
require "humanize"
require "date"

class MyAccountPage < Page
  include Capybara::DSL
  include WaitForAjax
  def initialize
    super
    @page_type = "my_account"
    setup
    grab_user_data
  end

  def grab_user_data
    @subscription_name = nil
    @rebill = nil
    if $test.user
      @subscription_name = $test.user.subscription.name
      @rebill = $test.user.rebill_date_db
    end
  end

  def get_subscriptions_list
    @subscripitons_list = page.all(:css, '[class*="subscription_header"]')
    puts @subscripitons_list
  end

  def go_to_subscriptions
    click_subs_link
    wait_for_ajax
  end

  def go_to_account_info
    click_account_info_link
    wait_for_ajax
  end

  def go_to_order_and_tracking
    click_order_and_tracking_link
    wait_for_ajax
  end

  def check_displayed_status(status)
    assert_text(status)
    case status
    when 'ACTIVE'
      assert_selector('div.status-active')
      assert_selector('div.status-active-tab')
    when 'SKIPPED'
      assert_selector('div.status-skipped')
      assert_selector('div.status-skipped-tab')
    when 'PENDING CANCELLATION'
      assert_selector('div.status-pending-cancellation')
      assert_selector('div.status-pending-cancellation-tab')
    when 'CANCELED'
      assert_selector('div.status-canceled')
      assert_selector('div.status-canceled-tab')
    when 'ON HOLD'
      assert_selector('div.status-on-hold')
      assert_selector('div.status-on-hold-tab')
    end
  end

  #need to make this validation more specific
  #in the case that the page has multiple subs
  def verify_subscription_added
    grab_user_data
    go_to_subscriptions
    expect(@subscription_name).not_to be_nil
    assert_text(@subscription_name)
    check_displayed_status("ACTIVE")
    wait_for_ajax
    if $test.user.subscription.rebill_date
      assert_text(localize_date($test.user.subscription.rebill_date['day'], $test.user.subscription.rebill_date['month_abbr'], $test.user.subscription.rebill_date['year']))
    else
      assert_text(get_expected_next_bill_date(@subscription_name)) unless @rebill
      assert_text(@rebill) if @rebill
    end
    assert_text(@first_name)
    assert_text(@last_name)
    assert_text(@ship_street)
    unless @use_shipping
      assert_text(@bill_street)
    end
  end

  #need to make this validation more specific
  #in the case that the page has multiple subs
  def verify_levelup_subscription_added
    go_to_subscriptions
    assert_text($test.user.level_up_subscription_name)
  end

  def verify_user_information
    go_to_account_info
    assert_text($test.user.email)
    assert_text($test.user.full_name)
  end

  def subscription_cancelled?
    go_to_subscriptions
    assert_text("REACTIVATE")
    check_displayed_status("CANCELED")
  end

  def subscription_updated?(size_type = 'shirt')
    go_to_subscriptions
    open_looter_info_tab
    assert_text($test.user.new_user_sub_name)
    assert_text($test.user.new_rebill_date)
    case size_type 
    when 'shirt'
      assert_text($test.user.subscription.sizes[:shirt])
    when 'pets'
      assert_text($test.user.subscription.sizes[:pet_collar])
      assert_text($test.user.subscription.sizes[:pet_shirt])
      assert_text($test.user.subscription.sizes[:unisex_shirt])
    end
  end

  def rebill_date_updated?
    go_to_subscriptions
    assert_text($test.user.new_rebill_date)
  end

  def shipping_info_updated?
    go_to_subscriptions
    open_shipping_tab
    assert_text($test.user.first_name)
    assert_text($test.user.last_name)
    assert_text($test.user.ship_street)
    assert_text($test.user.ship_city)
    assert_text($test.user.ship_state)
    assert_text($test.user.ship_zip)
  end

  def billing_info_updated?
    go_to_subscriptions
    open_payment_tab
    assert_text($test.user.full_name)
    assert_text($test.user.billing_address.street)
    assert_text($test.user.billing_address.city)
    assert_text($test.user.billing_address.state)
    assert_text($test.user.billing_address.zip)
    assert_text($test.user.subscription.billing_info.last_four)
  end

  def get_expected_next_bill_date(subscription_name, compare_date: nil)
    #if /1 Year Subscription/.match(subscription_name)
    #  months = 12
    #else
    #  months = subscription_name.gsub(/\D/, '').to_i
    #end
    if compare_date.nil?
      rebill_date = $test.calculate_rebill_date
      compare_date = localize_date(rebill_date['day'], rebill_date['month_abbr'], rebill_date['year'])
    end
    return compare_date
  end

  def localize_date(day, month, year)

    #if selected language is german:
    # return day + ". " + month + " " + year
    #else
    return month + " " + day + ", " + year
  end

  def cancellation_pending?
    for i in 0..2 do
      if page.has_content?('survey')
        page.find_link('No thanks').click
        break
      end
    end
    check_displayed_status("PENDING CANCELLATION")
    assert_text("REMOVE CANCELLATION")
  end

  def month_skipped?
    go_to_subscriptions
    check_displayed_status("SKIPPED")
    assert_text("(You have skipped")
  end

  def sub_on_hold?
    go_to_subscriptions
    check_displayed_status("ON HOLD")
  end

  def cannot_skip_again?
    go_to_subscriptions
    open_payment_tab
    for i in 0..2
      if page.has_content?("CANCEL SUBSCRIPTION")
        break
      end
    end
    #TO DO - add validation for skipped month
    find_link("Cancel Subscription").click
    assert_text("WE'RE SORRY YOU NEED TO GO")
  end

  def cancel_subscription
    go_to_subscriptions
    get_expected_next_bill_date($test.user.subscription.name)
    click_cancel_subscription
    find_link("Cancel Subscription").click
    sleep(1)
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax
  end

  def click_cancel_subscription
    open_payment_tab
    wait_for_ajax
    find_link("Cancel Subscription").click
    wait_for_ajax
  end

  def skip_a_month
    go_to_subscriptions
    open_payment_tab
    for i in 0..2
      if page.has_content?("SKIP")
        break
      end
    end
    find_link("SKIP").click
    find_link("SKIP A MONTH").click
    wait_for_ajax
    find_link("MANAGE ACCOUNT").click
    wait_for_ajax
  end

  def skip_during_cancel
    click_subs_link
    open_payment_tab
    for i in 0..2
      if page.has_content?("CANCEL SUBSCRIPTION")
        break
      end
    end
    find_link("Cancel Subscription").click
    find_link("SKIP A MONTH").click
    wait_for_ajax
  end

  def click_subs_link
    find_link("Subscriptions").click
  end

  def click_account_info_link
    find_link("Account Info").click
  end

  def click_order_and_tracking_link
    find_link("Order & Tracking").click
  end

  def reactivate_subscription
    go_to_subscriptions
    find_link("Reactivate").click
    unless $test.user.promo.nil?
      apply_coupon
    end
    find_button("Submit").click
  end

  def apply_coupon
    fill_in("coupon_code", :with => $test.user.promo.coupon_code)
    find_link("Validate Coupon").click
    wait_for_ajax
    expect(find("div#coupon-status").text).not_to eq("Invalid Coupon")
    sleep(5)
  end

  def open_payment_tab
    find_link("Payment Info").click
    wait_for_ajax
  end

  def open_looter_info_tab
    find_link("Looter Info").click
    wait_for_ajax
  end

  def open_shipping_tab
    find_link("Shipping Info").click
    wait_for_ajax
  end

  def subscription_reactivated?
    check_displayed_status("ACTIVE")
    expect(page.has_content?("UPGRADE")).to be_truthy
  end

  def edit_subscription_info(sub_id)
    go_to_subscriptions
    find(:css,"#panel-one-cog-#{sub_id}-lnk > i").click
    find_link("Edit").click
  end

  def fill_in_subscription_name(sub_id, name)
    fill_in('subscription_name' + sub_id, :with => name)
    $test.user.new_user_sub_name = name
  end

  def select_shirt_size(sub_id, size)
    #find('#select2-subscription_subscription_variants_attributes_0_variant_id-container').click
    #find('.select2-results__option', :text => size).click
    select "#{size}", :from => 'subscription_subscription_variants_attributes_0_variant_id'
    $test.user.subscription.sizes[:shirt] = size
  end

  #pets variants show up in a random order
  #this function is to help find the correct drop down give a label
  def find_size_dropdown_id(label)
    size_dd_elements = page.all('div.subscription_subscription_variants_variant')
    size_dd_elements.each do |element|
      if element.find('label').text == label
        return element.find('select')['id']
      end
    end
    raise "No dropdown with label #{label}!"
  end

  def select_human_wearable_size(sub_id, size)
    id = find_size_dropdown_id("Human Wearable Size")
    select "#{size}", :from => id
    $test.user.subscription.sizes[:unisex_shirt] = size
  end

  def select_pet_collar_size(sub_id, size)
    id = find_size_dropdown_id("Collar Size")
    select "#{size}", :from => id
    $test.user.subscription.sizes[:pet_collar] = size
  end

  def select_pet_wearable_size(sub_id, size)
    id = find_size_dropdown_id("Pet Wearable Size")
    select "#{size}", :from => id
    $test.user.subscription.sizes[:pet_shirt] = size
  end

  def verify_populated_dropdown
    options = find_all("#subscription_subscription_variants_attributes_0_variant_id option")
    options.each do |o|
      expect(o.text).to be_truthy
      expect(o.text).not_to eq('')
    end
  end

  def edit_shipping_address(sub_id)
    go_to_subscriptions
    open_shipping_tab
    sleep(1)
    find(:css, "#panel-three-cog-#{sub_id}-lnk > i").click
    find_link("Edit").click
  end

  def fill_in_shipping_first_name(sub_id, first_name)
    fill_in("shipping_address_first_name#{sub_id}", :with => first_name)
    $test.user.first_name = first_name
  end

  def fill_in_shipping_last_name(sub_id, last_name)
    fill_in("shipping_address_last_name#{sub_id}", :with => last_name)
    $test.user.last_name = last_name
  end

  def fill_in_shipping_address_1(sub_id, address_1)
    fill_in("shipping_address_line_1_#{sub_id}", :with => address_1)
    $test.user.ship_street = address_1
  end

  def fill_in_shipping_city(sub_id, city)
    fill_in("shipping_address_city#{sub_id}", :with => city)
    $test.user.ship_city = city
  end

  def fill_in_shipping_zip(sub_id, zip)
    fill_in("shipping_address_zip#{sub_id}", :with => zip)
    $test.user.ship_zip = zip
  end

  def select_shipping_state(sub_id, state)
    #find("#select2-shipping_address_state#{sub_id}-container").click
    #wait_for_ajax
    #find(".select2-results__option", :text => state).click
    select "#{state}", :from => "shipping_address_state#{sub_id}"
    $test.user.ship_state = state
  end

  def edit_billing_info(sub_id)
    go_to_subscriptions
    open_payment_tab
    sleep(1)
    find(:css, "#panel-two-cog-#{sub_id}-lnk > i").click
    find_link("Edit").click
  end

  def fill_in_cc_name(sub_id, name)
    fill_in("payment_method_full_name#{sub_id}", :with => name)
    $test.user.full_name = name
  end

  def fill_in_cc_number(cc)
    find(:css, "input.number").set(cc)
    $test.user.subscription.billing_info.set_cc_num(cc)
  end

  def fill_in_cvv_number(cvv)
    find(:css, "input.cvv").set(cvv)
    $test.user.subscription.billing_info.cvv = cvv
  end

  def fill_in_billing_address_1(sub_id, address)
    fill_in("payment_method_line_1_#{sub_id}", :with => address)
    $test.user.billing_address.street = address
  end

  def fill_in_billing_city(sub_id, city)
    fill_in("payment_method_city#{sub_id}", :with => city)
    $test.user.billing_address.city = city
  end

  def select_billing_state(sub_id, state)
    find("#select2-payment_method_state#{sub_id}-container").click
    wait_for_ajax
    find('.select2-results__option', :text => state).click
    $test.user.billing_address.state = state
  end

  def fill_in_billing_zip(sub_id, zip_code)
    fill_in("payment_method_zip#{sub_id}", :with => zip_code)
    $test.user.billing_address.zip = zip_code
  end

  def click_update
    find_button('Update').click
    wait_for_ajax
    assert_text('updated')
  end

  def tracking_info_displayed?
    go_to_subscriptions
    go_to_order_and_tracking
    assert_text('Tracking')
    assert_text('ABC123')
  end

  def unskip_subscription
    find_link('Un-Skip').click
    find_link('Confirm').click
  end

  def unskip_confirmation
    assert_text('You have successfully un-skipped!')
  end

end
