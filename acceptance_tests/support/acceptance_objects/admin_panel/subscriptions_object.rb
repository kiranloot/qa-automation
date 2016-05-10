require_relative "admin_object"
class AdminSubscriptionsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  def admin_cancel_immediately
    filter_for_subscription
    page.find_link('Cancel').click
    for i in 0..2
      if page.has_content?('CANCEL IMMEDIATELY')
        break
      end
    end
    page.find_link('CANCEL IMMEDIATELY').click
    sleep(1)
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax
    assert_text('Successfully cancelled subscription.')
  end

  def cancellation_successful?
    filter_for_subscription
    page.find_link('Reactivate')
    assert_text('CANCELED')
  end

  def subscription_status_is(status)
    click_subscriptions
    filter_for_subscription
    assert_text(status)
    if status == 'CANCELED'
      page.find_link('Reactivate')
    end
  end

  def filter_for_subscription
    for i in 0..2
      if page.has_content?("USER EMAIL")
        break
      end
    end
    page.find('#q_user_email').set($test.user.email)
    page.find_button('Filter').click
  end

  def flag_subscription_as_invalid
    edit_subscription
    find(:css, 'div#flag-address-button a.flag-button').click
    sleep(1)
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax
  end

  def reactivation_successful?
    filter_for_subscription
    assert_text("ACTIVE")
    assert_text("Cancel")
  end

  def reactivate_subscription
    filter_for_subscription
    find_link('Reactivate').click
  end

  def edit_subscription
    filter_for_subscription
    find_link('edit').click
  end

  def fill_in_subscription_name(name)
    fill_in('subscription_name', :with => name)
    $test.user.new_user_sub_name = name
  end

  def select_shirt_size(size)
    find(:id, 'subscription_subscription_variants_attributes_0_variant_id').click
    find(:css, '#subscription_subscription_variants_attributes_0_variant_id > option', :text => size).click
    $test.user.subscription.sizes[:shirt] = size
  end

  def move_rebill_date_one_day
    next_assessment = find(:id, 'subscription_next_assessment_at').value
    na_year = next_assessment[0..3]
    na_month = next_assessment[5..6]
    na_date = next_assessment[8..9]
    find(:id, 'subscription_next_assessment_at').click
    cur_date = find(:css, 'a.ui-state-active').text
    cur_date.to_i > 27 ? new_na_date = 1 : new_na_date = (cur_date.to_i + 1)
    find_link(new_na_date.to_s).click
    new_na_date < 10 ? new_na_date = "0" + new_na_date.to_s : new_na_date = new_na_date.to_s
    na_month = Date::MONTHNAMES[na_month.to_i]
    $test.user.new_rebill_date = "#{na_month} #{new_na_date}, #{na_year}"
  end

  def click_update_subscription
    find(:css, '#subscription_submit_action > input').click
    wait_for_ajax
    assert_text("Successfully updated subscription.")
  end

  def show_subscription
    filter_for_subscription
    find_link('show').click
  end

  def subscription_information_displayed?
    #$test.set_subject_user
    assert_text($test.user.email)
    assert_text($test.user.subscription.sizes[:shirt])
    assert_text($test.user.subscription.plan_title.downcase)
    assert_text($test.user.ship_zip)
    assert_text($test.user.ship_city)
    assert_text($test.user.ship_street)
    assert_text($test.user.ship_state)
  end

  def sub_billing_information_displayed?
    #$test.set_subject_user
    assert_text($test.user.full_name)
    assert_text($test.user.bill_street)
    assert_text($test.user.bill_city)
    assert_text($test.user.bill_zip)
    assert_text($test.user.subscription.billing_info.last_four)
  end

  def subscription_info_updated?(size_type = 'shirt')
    show_subscription
    #$test.set_subject_user
    assert_text($test.user.new_user_sub_name)
    case size_type
    when 'shirt'
      assert_text($test.user.subscription.sizes[:shirt])
    when 'pets'
      assert_text($test.user.subscription.sizes[:pet_collar])
      assert_text($test.user.subscription.sizes[:pet_shirt])
      assert_text($test.user.subscription.sizes[:unisex_shirt])
    end
  end

  def sub_tracking_information_displayed?
    assert_text('ABC123')
  end
end
