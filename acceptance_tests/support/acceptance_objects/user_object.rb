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
    :cc, :cvv, :ship_street, :ship_street_2, :ship_city, :affiliate, :coupon_code, :discount_applied, :subject_user, 
    :subscription_name, :level_up_subscription_name, :new_user_sub_name,:new_rebill_date, :bill_zip,
    :bill_city, :bill_street, :bill_street_2, :bill_state, :need_sub, :rebill_date_db, :last_four, :trait,
    :country_code

  @@sizes = {"male" =>  {0 => "Mens - S", 1 => "Mens - M", 2 => "Mens - L", 3 => "Mens - XL", 
                         4 => "Mens - XXL", 5 => "Mens - XXXL" },
           "female" => {0 => "Womens - S", 1 => "Womens - M", 2 => "Womens - L", 3 => "Womens - XL", 
                        4 => "Womens - XXL", 5 => "Womens XXXL"}}
  def initialize(test)
    @trait = nil
    @email = "placeholder"
    @password ="password"
    @first_name = "placeholder"
    @last_name = "placeholder"
    @full_name = @first_name + " " + @last_name
    @gender = rand(2)? "male":"female"
    @shirt_size = @@sizes[@gender][rand(6)]
    @display_shirt_size = get_display_shirt_size(@shirt_size)
    @ship_zip = "90210"
    @ship_city = "Beverly Hills"
    @ship_street = "1234 Fake St"
    @ship_street_2 = nil
    @ship_state = "CA"
    @cc = "4111111111111111" 
    @cvv = "333"
    @last_four = "1111" 
    @test = test
    @use_shipping = true
    @bill_zip = "90630"
    @bill_city = "Cypress"
    @bill_street = "5432 Test Ave"
    @bill_street_2 = nil
    @bill_state = nil
    @coupon_code = nil
    @tax_applied = false
    @discount_applied = nil
    @subject_user = nil
    @new_user_sub_name = nil
    @new_shirt_size= nil
    @new_rebill_date= nil
    @need_sub = true
    @plan_months = 0
    @rebill_date_db = nil
    @country_code
  end


  def configure_from_input(input_hash)
    input_hash.each do |k,v|
      self.instance_variable_set('@'+ k, v)
    end
    target_plan(@plan_months)
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

  def target_plan(months)
    months = word_for_digits(months) if months.to_i.to_s == months
    months.strip!
    case months
    when "one"
      @subscription_name = '1 Month Subscription'
    when "three"
      @subscription_name = '3 Month Subscription'
    when "six"
      @subscription_name = '6 Month Subscription'
    when "twelve"
      @subscription_name = '1 Year Subscription'
    end
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
      @level_up_subscription_name = 'Level Up Accessory 1 Month'
    elsif product == 'accessory' && months == 'three'
      @level_up_subscription_name = 'Level Up Accessory 3 Month'
    elsif product == 'accessory' && months == 'six'
      @level_up_subscription_name = 'Level Up Accessory 6 Month'
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
  
  def submit_subscription_info
    enter_shirt_size
    enter_first_and_last
    enter_shipping_info
    submit_credit_card_information
    unless @use_shipping
    enter_billing_info
    end
    unless @coupon_code.nil?
      enter_coupon_info
    end
    if @ship_state == "CA"
      if page.has_content?("Sales Tax CA")
        @tax_applied = true
      end
    end
    click_button(@test.test_data["locators"]["checkout_btn"])
    wait_for_ajax
    if @cc == '4111111111111111' && $test.current_page.page_type != 'fallout4'
      assert_text('Thank you for subscribing!')
    end
  end

  def submit_credit_card_information
    fill_in(@test.test_data["locators"]["name_on_card"], :with => @first_name + " " + @last_name)
    fill_in(@test.test_data["locators"]["cc"], :with => @cc)
    fill_in(@test.test_data["locators"]["cvv"], :with => @cvv)
  end   

  def submit_express_checkout_info
    fill_in(@test.test_data["locators"]["first_name"], :with => @first_name)
    fill_in(@test.test_data["locators"]["last_name"], :with => @last_name)
    fill_in(@test.test_data["locators"]["ship_street"], :with => @ship_street)
    unless @ship_street_2.nil?
      fill_in(@test.test_data["locators"]["ship_street_2"], :with => @ship_street_2)
    end
    fill_in(@test.test_data["locators"]["ship_city"], :with => @ship_city)
    page.find(@test.test_data["locators"]["state_dd_express"]).click
    page.find(@test.test_data["locators"]["ship_state_express"]).native.send_keys(@ship_state)
    page.find(@test.test_data["locators"]["ship_state_express"]).native.send_key(:enter)
    page.find(@test.test_data["locators"]["shirt_dd"]).click
    page.find(@test.test_data["locators"]["shirt_size_express"]).native.send_keys(@shirt_size)
    page.find(@test.test_data["locators"]["shirt_size_express"]).native.send_key(:enter)
    fill_in(@test.test_data["locators"]["ship_zip"], :with => @ship_zip)
    find_button("Next").click
    submit_credit_card_information
    find_button("Next").click
    find(:id, "checkout").click 
    wait_for_ajax
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

  def submit_levelup_subscription_info
    wait_for_level_up_autofill
    submit_credit_card_information
    click_button(@test.test_data["locators"]["checkout_btn"])
    wait_for_ajax
    assert_text("CONGRATULATIONS! YOU'VE SUCCESSFULLY LEVELED UP!")
  end
 
  def tax_applied?
    return @tax_applied
  end
  
  def set_data_status(data, status)
    if status == "invalid"
      case data
      when "credit card", "cc"
        @cc = '4567890133334444'
      end
    end
  end

  def verify_email(type, mailer)
    if type == 'subscription confirmation'
      target_content = 'Welcome to Loot Crate'
    elsif type == 'subscription cancellation'
      target_content = 'Subscription Cancellation'
    elsif type == 'upgrade'
      target_content = 'Subscription Upgraded'
    elsif type == 'skip'
      target_content = 'Subscription Skipped'
    elsif type == 'level up'
      target_content = 'LevelUp Purchase Confirmation'
    end
    mailer.email_log_in(@email)
     for i in 0..5
       unless page.has_content?(target_content)
         visit current_url
       end
     end
     assert_text(target_content)
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
     current_plan = Plan.new(current_month_int, Date.today, false)
     upgrade_plan_target = Plan.new(upgrade_month_int, Date.today, true)
   end
   @test.visit_page(:my_account)
   page.find_button("account-section-menu").click
   click_link("Subscriptions")
   click_link("Upgrade")
   select(upgrade_plan_target.subscription_display_name, :from => @test.test_data['locators']['upgrade_select'])
   click_button("SUBMIT")
   wait_for_ajax
   @subscription_name = upgrade_plan_target.subscription_display_name
  end

  def set_country(country, top_bot: nil)
    #country_code = @test.test_data['countries'][country]
    top = true
    if top_bot
      if top_bot == "top"
        top = true
      elsif top_bot == "bot" || top_bot == "bottom"
        top = false
      end
    else
      top = [true, false].sample
    end
    page.has_content?("Ship to")
    first(:link, "country-selector-lnk").click
    click_link(country)
  end

  def discount_applied?
    expect(@discount_applied).to be_truthy
  end

  def toggle_password
    @password = @password == "password" ? "secondary" : "password"
  end

  def plan_months
    @subscription_name.gsub(/[^\d]/, '').to_i
  end

end
