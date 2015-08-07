class User
  require 'capybara/cucumber'
  require 'date'
  require 'humanize'
  require 'rspec/matchers'
  include Capybara::DSL
  include RSpec::Matchers
  include WaitForAjax
  attr_accessor :email, :password, :street, :city, :ship_state, :ship_zip,
    :zip, :first_name, :last_name, :full_name, :shirt_size, :new_shirt_size, :cc, :cvv, :ship_street, :ship_city, :affiliate,
    :coupon_code, :discount_applied, :subject_user, :subscription_name, :level_up_subscription_name, :new_user_sub_name,
    :new_rebill_date

  @@sizes = {"male" =>  {0 => "Mens - S", 1 => "Mens - M", 2 => "Mens - L", 3 => "Mens - XL", 
                         4 => "Mens - XXL", 5 => "Mens - XXXL" },
           "female" => {0 => "Womens - S", 1 => "Womens - M", 2 => "Womens - L", 3 => "Womens - XL", 
                        4 => "Womens - XXL", 5 => "Womens XXXL"}}
  def initialize(test)
    @email = "placeholder"
    @password ="placeholder"
    @first_name = "placeholder"
    @last_name = "placeholder"
    @full_name = @first_name + " " + @last_name
    @gender = rand(2)? "male":"female"
    @shirt_size = @@sizes[@gender][rand(6)]
    @ship_zip = "90210"
    @ship_city = "Beverly Hills"
    @ship_street = "1234 Fake St"
    @ship_street_2 = nil
    @ship_state = "CA"
    @cc = "1" 
    @cvv = "333"
    @test = test
    @use_shipping = true
    @bill_zip = "90630"
    @bill_city = "Cypress"
    @bill_street = "5432 Test Ave"
    @bill_street_2 = nil
    @coupon_code = nil
    @tax_applied = false
    @discount_applied = nil
    @subject_user = nil
    @new_user_sub_name = nil
    @new_shirt_size= nil
    @new_rebill_date= nil
  end

  def target_plan(months)
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
  
  def submit_subscription_info
    page.find(@test.test_data["locators"]["shirt_dd"])
    page.find(@test.test_data["locators"]["shirt_dd"]).click
    find_button("SUBSCRIBE")
    page.find(@test.test_data["locators"]["shirt_size"]).native.send_keys(@shirt_size)
    page.find(@test.test_data["locators"]["shirt_size"]).native.send_key(:enter)
    fill_in(@test.test_data["locators"]["first_name"], :with => @first_name)
    fill_in(@test.test_data["locators"]["last_name"], :with => @last_name)
    fill_in(@test.test_data["locators"]["ship_street"], :with => @ship_street)
    unless @ship_street_2.nil?
      fill_in(@test.test_data["locators"]["ship_street_2"], :with => @ship_street_2)
    end
    fill_in(@test.test_data["locators"]["ship_city"], :with => @ship_city)
    page.find(@test.test_data["locators"]["state_dd"]).click
    find_link("Community")
    page.find(@test.test_data["locators"]["ship_state"]).native.send_keys(@ship_state)
    page.find(@test.test_data["locators"]["ship_state"]).native.send_key(:enter)
    fill_in(@test.test_data["locators"]["ship_zip"], :with => @ship_zip)
    submit_credit_card_information
    unless @use_shipping
      click_button(@test.test_data["locators"]["billing_cb"])
      fill_in(@test.test_data["locators"]["bill_street"], :with => @bill_street)
      fill_in(@test.test_data["locators"]["bill_city"], :with => @bill_city)
      page.find(@test.test_data["locators"]["bill_state_dd"]).click
      find_link("Community")
      page.find(@test.test_data["locators"]["bill_state"]).native.send_keys(@bill_state)
      page.find(@test.test_data["locators"]["bill_state"]).native.send_key(:enter)
      fill_in(@test.test_data["locators"]["bill_zip"], :with => @bill_zip)
    end
    unless @coupon_code.nil?
      find(:id, 'coupon-checkbox').click
      fill_in(@test.test_data["locators"]["coupon_code"], :with => @coupon_code)
      page.find_button("validate-coupon").click
      @discount_applied = page.has_content?("Coupon valid: save $")
    end
    if @ship_state == "CA"
      if page.has_content?("Sales Tax CA")
        @tax_applied = true
      end
    end
    click_button(@test.test_data["locators"]["checkout_btn"])
    page.has_content?('Thank you for subscribing!')
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

  def submit_levelup_subscription_info
    submit_credit_card_information
    click_button(@test.test_data["locators"]["checkout_btn"])
    page.has_content?('Leveled Up!')
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
   select(upgrade_plan_target.subscription_name, :from => @test.test_data['locators']['upgrade_select'])
   click_button("SUBMIT")
   wait_for_ajax
   @subscription_name = upgrade_plan_target.subscription_display_name
  end

  def set_country(country, top_bot: nil)
    country_code = @test.test_data['countries'][country]
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
    first(:link, "Ship to").click
        click_link(country_code + '-beta')
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
