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
    if $test.user
      @subscription_name = $test.user.subscription_name
    end
  end

  def get_subscriptions_list
    @subscripitons_list = page.all(:css, '[class*="subscription_header"]')
    puts @subscripitons_list
  end

  def verify_subscription_added
    page.find_button("account-section-menu").click
    page.find_link("Subscriptions").click
    assert_text(@subscription_name)
    assert_text("Active")
    if !page.has_content?(get_expected_next_bill_date(@subscription_name))
      visit current_url
    end
    assert_text(get_expected_next_bill_date(@subscription_name))
    assert_text(@first_name)
    assert_text(@last_name)
    assert_text(@ship_street)
    unless @use_shipping
      assert_text(@bill_street)
    end
  end

  def verify_levelup_subscription_added
    page.find_button("account-section-menu").click
    page.find_link("Subscription").click
    assert_text($test.user.level_up_subscription_name)
  end

  def verify_user_information
    page.find_button("account-section-menu").click
    page.find_link("Account Info").click
    assert_text($test.user.email)
    assert_text($test.user.full_name)
  end

  def subscription_cancelled?
    open_account_menu 
    click_subs_link
    page.find_link("Reactivate")
    assert_text("Canceled")
    assert_text("Reactivate")
  end

  def subscription_updated?
    open_account_menu
    click_subs_link
    assert_text($test.user.new_user_sub_name)
    assert_text($test.user.new_shirt_size)
    # Taking out this validation
    # Uncomment when IN-269 is resolved
    #assert_text($test.user.new_rebill_date)
  end

  def get_expected_next_bill_date(subscription_name, compare_date: nil)
    if subscription_name == '1 Year Subscription'
      months = 12
    else
      months = subscription_name.gsub(/\D/, '').to_i
    end
    if compare_date.nil?
      sub_day = Date.today
    if sub_day.day > 5 && sub_day.day < 20
      rebill_day = Date.new((sub_day >> months).year, 
                            (sub_day >> months).month, 5)
    else
      rebill_day = sub_day >> months
    end
      a = rebill_day.strftime('%B')
      b = rebill_day.strftime('%d')
      c = rebill_day.strftime('%Y')
      rebill_string = a + " " + b + ", " + c
      return rebill_string
    else
      #placeholder. May not need.
    end
  end

  def cancellation_pending?
    for i in 0..2 do
      if page.has_content?('survey')
        page.find_link('No thanks').click
        break
      end
    end
    assert_text("Pending Cancellation")
    assert_text("REMOVE CANCELLATION")
  end

  def month_skipped?
    open_account_menu
    click_subs_link
    #TO DO - add validation for skipped month
    assert_text("Active (You have skipped")
  end

  def cannot_skip_again?
    open_account_menu
    click_subs_link
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
    open_account_menu
    click_subs_link
    get_expected_next_bill_date($test.user.subscription_name)
    click_cancel_subscription
    find_link("CANCEL SUBSCRIPTION").click
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
    open_account_menu
    click_subs_link
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
    open_account_menu
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
    page.find_link("Subscriptions").click
  end

  def open_account_menu
    page.find_button("account-section-menu").click
  end

  def reactivate_subscription
    open_account_menu
    click_subs_link
    find_link("Reactivate").click
    find_button("Submit").click
  end

  def open_payment_tab
    find_link("Payment Info").click
  end

  def subscription_reactivated?
    assert_text("Active")
    expect(page.has_content?("UPGRADE")).to be_truthy
  end
  
end
