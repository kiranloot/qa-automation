require_relative "admin_object"
class AdminPromotionsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  #need to remove test data and break up
  def create_promotion(type)
    find_link("New Promotion").click
    rand_code = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    fill_in_promotion_description("Promotion Created by Automation")
    select_start_date("1")
    select_trigger_event("SIGNUP")
    select_all_plans
    fill_in_promotion_adjustment_amount(10)
    fill_in_promotion_coupon_prefix(rand_code)
    case type
    when 'multi use'
      fill_in_promotion_name("Multi Use Automation Promo #{rand_code}")
      fill_in_promotion_conversion_limit("10")
      click_create_promotion
    when 'one time use'
      fill_in_promotion_name("One Time Automation Promo #{rand_code}")
      click_one_time_use_checkbox
      fill_in_character_length("15")
      fill_in_quantity("1")
      click_create_promotion
      rand_code = get_one_time_promo_code(rand_code)
    end
    return rand_code
  end

  def fill_in_promotion_name(name)
    fill_in("promotion_name", :with => name)
  end

  def click_one_time_use_checkbox
    find(:id, "promotion_one_time_use").click
  end

  def fill_in_character_length(length)
    fill_in("char_length", :with => length)
  end

  def fill_in_quantity(quantity)
    fill_in("quantity", :with => quantity)
  end

  def fill_in_promotion_conversion_limit(limit)
    fill_in("promotion_conversion_limit", :with => limit)
  end

  def fill_in_promotion_description(description)
    fill_in("promotion_description", :with => description)
  end

  def fill_in_promotion_coupon_prefix(prefix)
    fill_in("promotion_coupon_prefix", :with => prefix)
  end

  def fill_in_promotion_adjustment_amount(amount)
    fill_in("promotion_adjustment_amount", :with => amount) 
  end

  def select_start_date(date)
    find(:id, "promotion_starts_at").click
    find(:css, "div.ui-datepicker-group-first").find_link(date).click
  end

  def select_trigger_event(event)
    find(:id,"s2id_promotion_trigger_event").click
    fill_in("s2id_autogen3", :with => event)
    find(:css, "div.select2-result-label").click
  end

  def select_all_plans
    find(:id, "select_all").click
  end

  def click_create_promotion
    find(:id, "btn-submit").click
    wait_for_ajax
    assert_text("Promotion Details")
  end

  def filter_promo_by_coupon_code(code)
    fill_in("q_coupons_code_cont", :with => code)
    find_button("Filter").click
    wait_for_ajax
  end

  def display_coupons_for_promo_by_prefix(code)
    filter_promo_by_coupon_code(code)
    find("#index_table_promotions").find_link("Coupons").click
    wait_for_ajax
  end

  def get_first_coupon_code(number_of = 5)
    number_of.times do
      if ( page.has_css?("tbody > tr td.col-code") )
        return find("tbody > tr td.col-code").text
      else
        page.driver.browser.navigate.refresh
      end
    end
  end

  def view_promo_by_code(code)
    filter_promo_by_coupon_code(code)
    find_link('View').click
    wait_for_ajax
  end

  def get_promo_id
    find(:css, 'tr.row-id td').text
  end

  def get_one_time_promo_code(code)
      click_promotions
      view_promo_by_code(code)
      promo_id = get_promo_id
      $test.db.poll_for_one_time_coupon_code(promo_id)
  end
end
