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
    wait_for_ajax
    page.driver.browser.switch_to.alert.accept
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
    admin = $test.user
    for i in 0..2
      if page.has_content?("USER EMAIL")
        break
      end
    end
    page.find('#q_user_email').set(admin.subject_user.email)
    page.find_button('Filter').click
  end

  def flag_subscription_as_invalid
    edit_subscription
    find(:css, 'div#flag-address-button a.flag-button').click
    wait_for_ajax
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
    find(:id, 'subscription_shirt_size').click
    case size
      when 'M S'
        selection = 2
      end
    find(:css, "#subscription_shirt_size > option:nth-child(#{selection})").click
    $test.user.new_shirt_size = size
  end

  def move_rebill_date_one_day
    find(:id, 'subscription_next_assessment_at').click
    cur_month = find(:css, 'span.ui-datepicker-month').text
    cur_year = find(:css, 'span.ui-datepicker-year').text
    cur_date = find(:css, 'a.ui-state-active').text
    cur_date = cur_date.to_i
    #just move rebill date to the first if after 27th
    #to account for feb
    if cur_date > 27
      new_date = 1
    else
      new_date = cur_date + 1
    end
    find_link("#{new_date}").click
    if new_date < 10
      new_date = "0" + new_date.to_s
    end
    $test.user.new_rebill_date = "#{cur_month} #{new_date}, #{cur_year}"
  end

  def click_update_subscription
    find(:id, 'subscription_submit_action').click
    wait_for_ajax
    assert_text("Successfully updated subscription.")
  end

  def show_subscription
    filter_for_subscription
    find_link('show').click
  end

  def subscription_information_displayed?
    $test.set_subject_user
    assert_text($test.user.email)
    assert_text($test.user.shirt_size)
    assert_text($test.user.subscription_name.downcase)
    assert_text($test.user.ship_zip)
    assert_text($test.user.ship_city)
    assert_text($test.user.ship_street)
    assert_text($test.user.ship_state)
  end
end
