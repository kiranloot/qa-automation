require_relative "admin_object"
class AdminPromotionsPage < AdminPage
  include WaitForAjax
  def initialize
    super
  end

  #need to remove test data and break up
  def create_promotion
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

end
