class Test
 require_relative 'user_object'
 require_relative 'homepage_object'
 require_relative 'signup_page_object'
 require_relative 'modules/wait_module'
 require_relative 'heroku_object'
 require 'yaml'
 require 'pry'
 require 'faker'
 require 'time'
 attr_accessor :user,
   :admin_user,
   :cms_user,
   :pages,
   :current_page,
   :price_estimate_data,
   :plan_cost_data,
   :db,
   :start_time,
   :affiliate,
   :recurly,
   :box,
   :sailthru,
   :mailinator
 include Capybara::DSL
 include WaitForAjax

 def initialize(price_data, cost_data, start_page, pages, db, box, mailinator_api)
  @affiliate = nil
  @user = nil
  @admin_user = nil
  @sailthru = SailthruAPI.new
  @current_page = start_page
  @price_estimate_data = price_data
  @plan_cost_data = cost_data
  @pages = pages
  @db = db
  @box = box
  @mailinator = mailinator_api
  @recurly = RecurlyAPI.new(box)
  @start_time = Time.now
 end

 def increment_digits(input_string)
   working = input_string
   values = working.split(/(\d+)/)
   numbers = values[1].to_i
   numbers += 1
   working = values[0] + numbers.to_s + values[2]
   return working
 end

 def modal_signup
   wait_for_ajax
   @current_page.modal_signup(@user.email, @user.password)
 end
#Move to parent page object
 def is_logged_in?
   find('#header-logo-lnk').click
   assert_text("MY ACCOUNT")
 end

 def link_not_visible(link)
   expect(page).to have_no_content(link)
 end

 def link_visible(link)
   expect(page).to have_content(link)
 end

 def visit_page(page)
   @current_page = @pages[page].new
   @current_page.visit_page
   wait_for_ajax
 end

 def select_crate(crate)
   find('#header-logo-lnk').click
   wait_for_ajax
   if ENV['DRIVER'] == 'appium'
     @current_page.click_hamburger
   end
   click_link("Pick a Crate")
   case crate
   when "Loot Crate"
     find("#header-lootcrate-lnk").click
     $test.current_page = LootcrateLandingPage.new
   when "Level Up"
     find("#header-level-up-lnk").click
     $test.current_page = LevelUpSubscribePage.new
   when "Anime"
     find("#header-anime-lnk").click
     $test.current_page = AnimeLandingPage.new
   when "Pets"
     find("#header-pets-lnk").click
     $test.current_page = PetsLandingPage.new
   when "Firefly"
     find("#header-firefly-lnk").click
     $test.current_page = FireflyLandingPage.new
   when "Gaming"
     find("#header-gaming-lnk").click
     $test.current_page = GamingLandingPage.new
   when "Star Wars™"
     find("#header-sw-lnk").click
     $test.current_page = StarWarsLandingPage.new
   when "Call of Duty®"
     find("#header-cod-lnk").click
     $test.current_page = CallofdutyLandingPage.new
   when "DX"
     find("#header-lcdx-lnk").click
     $test.current_page = DXLandingPage.new
   end
   $test.user.crate_type = crate
   wait_for_ajax
 end

 def is_at(page)
   if @current_page.instance_of?(@pages[page])
     return true
   else
     @current_page = @pages[page].new
     if current_url == @current_page.base_url
       return true
     else
       return false
     end
   end
 end

 def enter_password
  @current_page.pop_password(@user.password)
 end

 def configure_user(type, with_string = nil)
   ug = UserGen.new(type, with_string)
   @user = ug.build
   @user.set_full_name
   #Several tests still rely on matching billing/shipping info, so the following two methods are temporarily necessary
   @user.billing_address = Address.new(@user.ship_street, @user.ship_city, @user.ship_zip, @user.ship_state)
   @user.match_billing_shipping_address
  end

  def configure_billing_address
    @user.billing_address = FactoryGirl.build(:address, @user.country_code.to_sym)
  end


 def affiliate_working?
   visit_page(:home)
   @current_page.visit_with_affiliate(@affiliate.name)
   expect(current_url).to match(/#{@affiliate.redirect_url_escaped}/)
 end

 def affiliate_created?
   page.has_content?("Affiliate Details")
   assert_text("Affiliate was successfully created.")
   assert_text(@affiliate.name)
   assert_text(@affiliate.redirect_url)
 end

 def enter_login_info
   @current_page.enter_login_info(@user.email, @user.password)
   wait_for_ajax
 end

 def parse_with_args(arg_string)
   args = arg_string.downcase
   if args == "no prior subscription"
     return :registered_no_prior
   elsif args == "an active subscription"
     return :registered_with_active
   elsif /an? (.*?) address/.match(args)
     a = /an? (.*?) address/.match(args)
     address_type = a[1]
     return get_address_trait(address_type)
   elsif /an? (.*?) month subscription/.match(args)
     m = /an? (.*?) month subscription/.match(args)
     months = m[1]
     return (months + "_month").to_sym
   elsif args == 'a multi use promo code'
     return :multi_use_promo
   elsif args == "access to their info"
     return :subject_user
   elsif args == "a canceled subscription"
     return :canceled
   else
     puts ("Unknown with args submitted to user configuration")
   end
 end

 def get_address_trait(type)
   type_hash = {"denmark" => :denmark, "uk" => :uk, "germany" => :germany,
                "finland" => :finland, "france" => :france, "norway" => :norway,
                "newzealand" => :new_zealand, "ireland" => :ireland,
                "austrailia" => :austrailia, "netherlands" => :netherlands,
                "sweden" => :sweden, "ie" => :ireland, "de" => :germany,
                "dk" => :denmark, "nl" => :netherlands, "fr" => :france,
                "no" => :norway, "fi" => :finland, "nz" => :new_zealand,
                "au" => :austrailia, "se" => "sweden", "gb" => :uk,
                "california" => :california}
   if type != "random"
     return type_hash[type]
   else
     possibilities = type_hash.values
     return possibilities[rand(possibilities.size)]
   end

 end

 def submit_signup
   @current_page.submit_signup
 end

  def submit_information(adjective, type, addbilling=false)
    if type == 'signup' || type == 'registration'
      if adjective == 'valid'
        get_valid_signup_information
      else
        get_invalid_signup_information
      end
      @current_page.enter_register_info(@user)
    elsif type =='subscription'
      @current_page.submit_checkout_information(adjective, addbilling)
    elsif type == 'credit card'
      @current_page.submit_credit_card_information_only(adjective)
    end
  end

  def get_valid_signup_information
    @user.password = "qateam123"
    @user.email = "_unreg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com"
  end

  def get_invalid_signup_information
    @user.password = "short"
    @user.email = "bad_email@fake.com"
  end

  def give_user_to_admin
    admin_user = FactoryGirl.build(:user, :admin)
    admin_user.subject_user = @user
    @user = admin_user
  end

  #def set_subject_user
  #  if @user.subject_user
  #    @user = @user.subject_user
  #  end
  #end

  def setup_user_with_active_sub_rake
    api = HerokuAPI.new
    @user.email = api.create_user_with_active_sub
    @user.target_plan('one')
  end

  def setup_user_with_canceled_sub_rake
    api = HerokuAPI.new
    @user.email = api.create_user_with_canceled_sub
  end

  def email_footer_not_visible()
    expect(page).not_to have_field('#footer-mce-email', :type => 'email')
  end

  def all_coupon_codes_unique?
    results = $test.db.get_all_coupon_codes
    codes = []
    results.each do |result|
      codes << result['code']
    end
    return codes.uniq.length == codes.length
  end
end
