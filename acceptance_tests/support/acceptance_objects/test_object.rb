class Test
 require_relative 'user_object'
 require_relative 'homepage_object'
 require_relative 'signup_page_object'
 require_relative 'wait_module'
 require_relative 'heroku_object'
 require 'yaml'
 require 'pry'
 require 'faker'
 attr_accessor :user, :pages, :current_page, :test_data, :db, :affiliate, :recurly, :box, :sailthru, :mailinator
 include Capybara::DSL
 include RSpec::Matchers
 include WaitForAjax

 def initialize(test_data, start_page, pages, db, box, mailinator_api)
  @affiliate = nil
  @user = nil
  @recurly = RecurlyAPI.new
  @sailthru = SailthruAPI.new
  @current_page = start_page
  @test_data = test_data 
  @pages = pages
  @db = db
  @box = box
  @mailinator = mailinator_api
 end

 def update_test_data(value)
   should_write = true
  if value == "valid_email"
    data = increment_digits(@test_data["signup"][value])
    @test_data["signup"][value] = data
  elsif value == "email_sequence"
    data = @test_data["user"][value]
  elsif value == "registered_no_prior"
    data = increment_digits(@test_data["emails"]["registered_no_prior"])
    @test_data["emails"]["registered_no_prior"] = data
  elsif  value == "registered_with_active"
    data = increment_digits(@test_data["emails"]["registered_with_active"])
    @test_data["emails"]["registered_with_active"] = data
  else
    should_write = false
  end

  if should_write 
    File.open($env_test_data_file_path, 'w') {|f| f.write @test_data.to_yaml}
  else
    puts "Test data not updated: unrecognized data identifier."
  end
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
   @current_page.modal_signup(@user.email, @user.password, @test_data)
 end
#Move to parent page object
 def is_logged_in?
   assert_text("My Account")
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
   click_link("Pick a Crate")
   click_link(crate)
   wait_for_ajax
   case crate
   when "Loot Crate"
     $test.current_page = LootcrateSubscribePage.new
   when "Level Up"
     $test.current_page = LevelUpSubscribePage.new
   when "Anime"
     $test.current_page = AnimeSubscribePage.new
   when "Pets"
     $test.current_page = PetsSubscribePage.new
   end
 end

 def log_in_or_register
   if !page.has_content?("Log In")
     log_out
   end
   @current_page = SignupPage.new
   @current_page.visit_page
   if $test.db.user_exists?($test.user.email)
     sleep(1)
     find(:css, '#new-customer-container span.goOrange').click 
     wait_for_ajax
     unless (page.has_css?('#user_email'))
       find(:css, '#new-customer-container span.goOrange').click 
     end
     enter_login_info
   else 
     enter_email
     enter_password
     submit_signup
   end
 end
#Move to parent page object
 def log_out
   click_link("My Account")
   click_link("Log Out")
   wait_for_ajax
 end
#Remove middle man
 def get_valid_signup_information
  @user.password = @test_data["signup"]["valid_pw"]
  @user.email = "_unreg_" + Faker::Internet.user_name + rand(999).to_s + "@mailinator.com"
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
#Remove middle man
 def get_invalid_signup_information
   @user.password = @test_data["signup"]["invalid_pw"]
   @user.email = @test_data["signup"]["invalid_email"]
 end

 def enter_email
  @current_page.pop_email(@user.email)
 end

 def get_registered_email(has_prior)
   if !has_prior
     email =  @test_data["emails"]["registered_no_prior"]
     update_test_data("registered_no_prior")
   else 
     email = @test_data["emails"]["registered_with_active"]
     update_test_data("registered_with_active")
   end
   return email
 end

 def enter_password
  @current_page.pop_password(@user.password)
 end

 def configure_user(type, with_string = nil, new_way = true)
   if new_way
     ug = UserGen.new(type, with_string)
     @user = ug.build
     @user.set_full_name
   else
     if with_string != nil
      @user = get_user_with(type, with_string)
     else
       @user = get_user_type(type)
     end
     @user.set_full_name
   end
  end
 
 def get_user_type(type)
   if type == "registered"
     @user = FactoryGirl.build(:user, :registered)
   elsif type == "unregistered"
     @user = FactoryGirl.build(:user)
   elsif type == "admin"
     @user = FactoryGirl.build(:user, :admin)
   else
   end
 end

 def get_user_with(type, with_args)
     setup_type = parse_with_args(with_args)
     if type == "registered"
       @user = FactoryGirl.build(:user, setup_type)
     elsif type == "international"
       setup
     elsif type == "admin"
       if setup_type == :subject_user
         give_user_to_admin
      else
      end
     else
   end
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

  def submit_information(adjective, type)
    if type == 'signup' || type == 'registration'
      if adjective == 'valid'
        get_valid_signup_information
      else
        get_invalid_signup_information
      end
      enter_email
      enter_password
      submit_signup
    elsif type =='subscription'
      @current_page.submit_checkout_information(@user, adjective)
    elsif type == 'credit card'
      @current_page.submit_credit_card_information_only(@user, adjective)
    end
  end

  def verify_email(type)
    type.downcase!
    type.strip!
    #@current_page = Mailinator.new
    #@current_page.visit_page
    #the verify email function probably belongs in the mailinator object
    @user.verify_email(type, current_page)
  end

  def give_user_to_admin
    admin_user = FactoryGirl.build(:user, :admin)
    admin_user.subject_user = @user
    @user = admin_user
  end

  def set_subject_user
    if @user.subject_user
      @user = @user.subject_user
    end
  end

  def setup_user_with_active_sub_rake
    api = HerokuAPI.new
    @user.email = api.create_user_with_active_sub
    @user.target_plan('one')
  end

  def setup_user_with_canceled_sub_rake
    api = HerokuAPI.new
    @user.email = api.create_user_with_canceled_sub
  end

  def calculate_rebill_date
    if /Anime/.match($test.user.subscription_name)
      end_date = 28
    else
      end_date = 20
    end
    sub_day = Date.today
    if sub_day.day > 5 && sub_day.day < end_date
      rebill_day = Date.new((sub_day >> $test.user.plan_months).year,
                            (sub_day >> $test.user.plan_months).month, 5)
    else
      rebill_day = sub_day >> $test.user.plan_months
    end
    return{
      'month' => rebill_day.strftime('%B'),
      'day' => rebill_day.strftime('%d'),
      'year' => rebill_day.strftime('%Y')
    }
  end
end
