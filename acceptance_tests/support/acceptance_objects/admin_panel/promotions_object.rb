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
    fill_in("promotion_description", :with => "Promotion Created by Automation")
    find(:id, "promotion_starts_at").click
    find(:css, "div.ui-datepicker-group-first").find_link("1").click
    find(:id,"s2id_promotion_trigger_event").click
    fill_in("s2id_autogen3", :with => "SIGNUP")
    find(:css, "div.select2-result-label").click
    find(:id, "select_all").click
    fill_in("promotion_adjustment_amount", :with => "10")
    fill_in("promotion_coupon_prefix", :with => rand_code)
    case type
    when 'multi use'
      fill_in("promotion_name", :with => "Multi Use Automation Promo #{rand_code}")
      fill_in("promotion_conversion_limit", :with => "10")
      find(:id, "btn-submit").click
      wait_for_ajax
    when 'one time use'
      fill_in("promotion_name", :with => "One Time Automation Promo #{rand_code}")
      find(:id, "promotion_one_time_use").click
      fill_in("char_length", :with => "15")
      fill_in("quantity", :with => "1")
      find(:id, "btn-submit").click
      wait_for_ajax
      click_promotions
      display_coupons_for_promo_by_prefix(rand_code) 
      rand_code = get_first_coupon_code
    end
    return rand_code
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
end
