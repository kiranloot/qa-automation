require_relative "page_object"
class AdminPage < Page
  include WaitForAjax
  def initialize
    super
    @page_type = 'admin'
    setup
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

  def filter_for_subscription
    admin = $test.user
    page.find_link('Subscriptions').click
    for i in 0..2
      if page.has_content?("USER EMAIL")
        break
      end
    end
    page.find('#q_user_email').set(admin.subject_user.email)
    page.find_button('Filter').click
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

  def admin_log_out
    find_link("Logout").click
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

  def create_promotion
    find_link("Promotions").click
    find_link("New Promotion").click
    fill_in("promotion_name", :with => "Automation Promo")
    rand_code = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    fill_in("promotion_coupon_prefix", :with => rand_code)
    fill_in("promotion_conversion_limit", :with => "2")
    fill_in("promotion_description", :with => "Promotion Created by Automation")
    find(:id, "promotion_starts_at").click
    find(:css, "div.ui-datepicker-group-first").find_link("1").click
    find(:id,"s2id_promotion_trigger_event").click
    fill_in("s2id_autogen3", :with => "SIGNUP")
    find(:css, "div.select2-result-label").click
    find(:id, "select_all").click
    fill_in("promotion_adjustment_amount", :with => "10")
    find(:id, "btn-submit").click
    wait_for_ajax
    return rand_code
  end

  def set_variant_inventory(product_id,inventory,available)
    find_link("Variants").click
    find(:id, "variant_#{product_id}").find_link("Change Inventory").click
    fill_in("inventory_unit_total_available", :with => inventory)
    if available
      check("inventory_unit_in_stock")
    else
      uncheck("inventory_unit_in_stock")
    end
    find(:id, "inventory_unit_submit_action").click
    wait_for_ajax
  end
end
