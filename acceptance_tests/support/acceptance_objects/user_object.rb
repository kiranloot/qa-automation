class User
  require 'capybara/cucumber'
  require 'date'
  require 'humanize'
  require 'rspec/matchers'
  include Capybara::DSL
  include RSpec::Matchers
  include WaitForAjax

  attr_accessor :email, :password, :street, :city, :ship_state, :ship_zip, :zip,
    :first_name, :last_name, :full_name, :shirt_size, :display_shirt_size, :new_shirt_size,
    :cc, :cvv, :ship_street, :ship_street_2, :ship_city, :affiliate, :base_coupon_code, :coupon_code, :discount_applied,
    :subscription_name, :level_up_subscription_name, :new_user_sub_name,:new_rebill_date, :bill_zip,
    :bill_city, :bill_street, :bill_street_2, :bill_state, :need_sub, :rebill_date_db, :last_four, :trait, :recurly_level_up_plan,
    :country_code, :recurly_billing_state_code, :cc_invalid, :cc_exp_month, :cc_exp_year, :pet_shirt_size, :pet_collar_size, :human_wearable_size, :promo_type,
    :promo, :adjustment_type, :adjustment_amount, :recurly_rebill_date, :unisex_shirt_size, :pin_code, :crate_type, :billing_address, :country, :subscription

  @@sizes = {"male" =>  {0 => "Mens - S", 1 => "Mens - M", 2 => "Mens - L", 3 => "Mens - XL",
                         4 => "Mens - XXL", 5 => "Mens - XXXL" },
           "female" => {0 => "Womens - S", 1 => "Womens - M", 2 => "Womens - L", 3 => "Womens - XL",
                        4 => "Womens - XXL", 5 => "Womens - XXXL"}}

  @@pet_shirt_sizes = ['Dog - XS', 'Dog - S', 'Dog - M', 'Dog - L', 'Dog - XL', 'Dog - XXL', 'Dog - XXXL']
  @@pet_collar_sizes = ['Dog - S', 'Dog - M', 'Dog - L']
  @@unisex_sizes = ['Unisex - S', 'Unisex - M', 'Unisex - L', 'Unisex - XL', 'Unisex - XXL', 'Unisex - XXX']

  def initialize(test)
    @trait = nil
    @email = "placeholder"
    @password = "qateam123"
    @first_name = "placeholder"
    @last_name = "placeholder"
    @full_name = @first_name + " " + @last_name
    @gender = ["male","female"].sample
    @shirt_size = @@sizes[@gender][rand(6)]
    @unisex_shirt_size = @@unisex_sizes.sample
    @pet_shirt_size = @@pet_shirt_sizes.sample
    @pet_collar_size = @@pet_collar_sizes.sample
    @human_wearable_size = @@unisex_sizes.sample
    @display_shirt_size = get_display_shirt_size(@shirt_size)
    @ship_zip = "90210"
    @ship_city = "Beverly Hills"
    @ship_street = "1234 Fake St"
    @ship_street_2 = nil
    @ship_state = "CA"
    @cc = "4111111111111111"
    @cc_invalid = "4567890133334444"
    @cc_exp_month = "01 - January"
    @cc_exp_year = "2020"
    @cvv = "333"
    @last_four = "1111"
    @test = test
    @use_shipping = true
    @bill_zip = "90210"
    @bill_city = "Beverly Hills"
    @bill_street = "1234 Fake St"
    @bill_street_2 = nil
    @bill_state = nil
    @coupon_code = nil
    @base_coupon_code = nil
    @tax_applied = false
    @discount_applied = nil
    #@subject_user = nil
    @new_user_sub_name = nil
    @new_shirt_size= nil
    @new_rebill_date= nil
    @recurl_rebill_date= nil
    @need_sub = true
    @rebill_date_db = nil
    @country_code = nil
    @recurly_billing_state_code = nil
    @recurly_level_up_plan = nil
    @promo = nil
    @promo_type = nil
    @adjustment_type = nil
    @adjustment_amount = nil
    @pin_code = nil
    @crate_type = nil
    @billing_address = nil
  end


  def configure_from_input(input_hash)
    input_hash.each do |k,v|
      self.instance_variable_set('@'+ k, v)
    end
    target_plan(input_hash)
    @shirt_size = scrub_shirt_size(@shirt_size)
    @rebill_date_db = scrub_rebill_date(@rebill_date_db)
    set_full_name
  end

  def need_sub?
    @need_sub
  end

  def scrub_rebill_date(str)
    r = /\d\d\d\d-\d\d-\d\d/
    x = r.match(str)
    dt = Date.parse(x[0])
    final = dt.strftime('%B') + " " + dt.strftime('%d') + ", " + dt.strftime('%Y')
    final
  end

  def target_plan(input_hash)
    plan_name = input_hash['plan_name']
    #remove the "Loot Crate" from the subscription name
    plan_name = plan_name.gsub(/Loot Crate/, '')
    @subscription_name = plan_name
  end

  def set_full_name
    @full_name = @first_name + " " + @last_name
  end

  def scrub_shirt_size(str)
    if str.include?("-")
      return str
    else
      s = str.include?("W") ? str.gsub("W", "Womens - "): str.gsub("M ", "Mens - ")
      return  s
    end
  end

  def group_shipping_info
    #NOT FINISHED
    s_info = { ship_street: @ship_street, ship_street_2: @ship_street_2 }
  end

  def get_display_shirt_size(size)
    match_data = /^(.{1}).*-\s(.*)$/.match(size)
    match_data[1] + " " + match_data[2]
  end

  def target_level_up_plan(product, months)
    months.strip!
    if product == 'socks' && months == 'one'
      @level_up_subscription_name = 'Level Up Socks 1 Month'
    elsif product == 'socks' && months == 'three'
      @level_up_subscription_name = 'Level Up Socks 3 Month'
    elsif product == 'socks' && months == 'six'
      @level_up_subscription_name = 'Level Up Socks 6 Month'
    elsif product == 'accessory' && months == 'one'
      @level_up_subscription_name = 'Level Up Accessories 1 Month'
    elsif product == 'accessory' && months == 'three'
      @level_up_subscription_name = 'Level Up Accessories 3 Month'
    elsif product == 'accessory' && months == 'six'
      @level_up_subscription_name = 'Level Up Accessories 6 Month'
    end
  end

  def save!
   puts "SAVE FUNCTION IS PLACEHOLDER!!!"
  end

  def enter_shirt_size
    page.find(@test.test_data["locators"]["shirt_dd"])
    page.find(@test.test_data["locators"]["shirt_dd"]).click
    wait_for_ajax
    page.find(@test.test_data["locators"]["shirt_size"]).native.send_keys(@shirt_size)
    page.find(@test.test_data["locators"]["shirt_size"]).native.send_key(:enter)
  end

  def enter_first_and_last
    fill_in(@test.test_data["locators"]["first_name"], :with => @first_name)
    fill_in(@test.test_data["locators"]["last_name"], :with => @last_name)
  end

  def enter_shipping_info
    fill_in(@test.test_data["locators"]["ship_street"], :with => @ship_street)
    unless @ship_street_2.nil?
      fill_in(@test.test_data["locators"]["ship_street_2"], :with => @ship_street_2)
    end
    fill_in(@test.test_data["locators"]["ship_city"], :with => @ship_city)
    page.find(@test.test_data["locators"]["state_dd"]).click
    wait_for_ajax
    page.find(@test.test_data["locators"]["ship_state"]).native.send_keys(@ship_state)
    page.find(@test.test_data["locators"]["ship_state"]).native.send_key(:enter)
    fill_in(@test.test_data["locators"]["ship_zip"], :with => @ship_zip)
  end

  def enter_billing_info
      click_button(@test.test_data["locators"]["billing_cb"])
      fill_in(@test.test_data["locators"]["bill_street"], :with => @bill_street)
      fill_in(@test.test_data["locators"]["bill_city"], :with => @bill_city)
      page.find(@test.test_data["locators"]["bill_state_dd"]).click
      wait_for_ajax
      page.find(@test.test_data["locators"]["bill_state"]).native.send_keys(@bill_state)
      page.find(@test.test_data["locators"]["bill_state"]).native.send_key(:enter)
      fill_in(@test.test_data["locators"]["bill_zip"], :with => @bill_zip)
  end

  def enter_coupon_info
      find(:id, 'coupon-checkbox').click
      fill_in(@test.test_data["locators"]["coupon_code"], :with => @coupon_code)
      page.find_button("validate-coupon").click
      @discount_applied = page.has_content?("Valid coupon: save $")
  end

  def wait_for_level_up_autofill(numberof = 5)
    numberof.times do
      if find(:id, @test.test_data["locators"]["ship_zip"]).value == @ship_zip
        break
      else
        sleep(1)
      end
    end
  end

  def tax_applied?
    return @tax_applied
  end

  def word_for_digits(i)
    words = ["zero", "one", "two", "three", "four",
             "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve"]
    words[i.to_i]
  end

  def upgrade_plan(months)
   upgrade_month_int = 0
   current_month_int = @subscription_name.gsub(/\D/, '').to_i
    for i in 0..12
     if i.humanize == months
      upgrade_month_int = i
     end
   end
   if upgrade_month_int <= current_month_int
     puts "Cannot upgrade: Upgrade plan months must be greater than current plan months"
     puts "Current plan Months: " + current_month_int
     puts "Upgrade plan Months: " + upgrade_month_int
   else
     current_plan = $test.user.subscription
     upgrade_plan_target = current_plan.class.new(months, current_plan.product)
   end
   #should probably be moved to the my accounts page object
   @test.visit_page(:my_account)
   click_link("Subscriptions")
   click_link("Upgrade")
   select(upgrade_plan_target.upgrade_string, :from => 'upgrade_plan_name')
   click_button("SUBMIT")
   wait_for_ajax
   @subscription_name = upgrade_plan_target.name
   @subscription = upgrade_plan_target
  end

  def is_country_us?
    wait_for_ajax
    page.has_css?('.country-selector-lnk img')
    return /assets\/flags\/us_flag/.match(first('.country-selector-lnk img')[:src])
  end

  def verify_country_flag
    find(:xpath, "//div[contains(@class, 'country-selector')]/*/img[contains(@src, '#{@country_code.downcase}_flag-')]")
  end

  def set_ship_to_country(country, top_bot: nil)
    unless $test.user.country == country
      $test.user.country_code = FactoryGirl.build(:user, country.tr(' ', '').downcase.to_sym).country_code
      $test.user.country = country
    end
    wait_for_ajax
    sleep(5)
    if ENV['DRIVER'] == 'appium'
      find(:css, "div.country-selector-mobile  a").click
    else
      find(:css, "div.country-selector.dropdown.country-selector-desktop > a").click
    end
    page.all("span.select2-selection__rendered")[1].click
    wait_for_ajax
    find(".select2-results__option", :text => country).click
    if ENV['DRIVER'] == 'appium'
      sleep(5)
    end
    wait_for_ajax
    verify_country_flag
  end

  def discount_applied?
    expect(@discount_applied).to be_truthy
  end

  def toggle_password
    @password = @password == "password" ? "secondary" : "password"
  end

  def plan_months
    if @subscription_name =~ /1 Year Subscription/
      return 12
    else
      @subscription_name.gsub(/[^\d]/, '').to_i
    end
  end

  def match_billing_shipping_address
    @bill_street = @ship_street
    @bill_street_2 = @ship_street_2
    @bill_city = @ship_city
    @bill_zip = @ship_zip
    @bill_state = @ship_state
  end

  ##Promotion creation methods
  def process_promotion_type(promo_type)
    promo_traits = []

    if promo_type.include?('reactivat')
      promo_traits << :trigger_reactivation
    end
    if promo_type.include?('one time use')
      promo_traits << :one_time_use
    end
    if promo_type.include?('upgrade')
      promo_traits << :trigger_upgrade
    end
    promo_traits
  end

  def get_promotion_adjustment_type(type)
    case type
    when /[Pp]ercent/
      type_trait = :percent
    else
      type_trait = :fixed
    end
    type_trait
  end

  def create_user_promotion(promo_type, adjustment_type = 'Fixed', adjustment_amount=10)
    traits = process_promotion_type(promo_type)
    traits << get_promotion_adjustment_type(adjustment_type)
    promo = FactoryGirl.build(:promotion, *traits, adjustment_amount: adjustment_amount.to_f)
    $test.user.promo = promo
  end
end
