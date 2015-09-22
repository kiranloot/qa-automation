class UserGen

  def initialize(type, arg_string)
    arg_string.downcase! if arg_string
    parse_args(type, arg_string) if arg_string
    set_simple(type) unless arg_string
    @country_code = nil
  end

  def parse_args(t, arg_string)
    @location_trait = false
    @month_trait = false
    @args = preprocess(arg_string)
    if @args.class == String
      @args = @args.split(" ")
      @args = @args.join("_")
    end
    @type = t
    @location_trait || @month_trait ? @trait = @args : @trait = self.send(@args)
    @country_code = "US" unless @country_code
  end

  def set_simple(type)
    @type = type
  end

  def preprocess(args)
    ret = args
    a = address_check(args)
    m = months_check(args)
    ret = is_address(a[1]) if a
    @location_trait = true if a
    ret = months(m[1]) if m
    @month_trait = true if m
    ret
  end

  def address_check(args)
    a = /an? (.*?) address/.match(args)
    a
  end

  def is_address(place)
    address_trait(place)
  end

  def months_check(args)
    m = /an? (.*?) month subscription/.match(args)
    m
  end

  def address_trait(country)
   type_hash = {"denmark" => :denmark, "uk" => :uk, "germany" => :germany,
                "finland" => :finland, "france" => :france, "norway" => :norway,
                "newzealand" => :new_zealand, "ireland" => :ireland,
                "austrailia" => :austrailia, "netherlands" => :netherlands,
                "sweden" => :sweden, "ie" => :ireland, "de" => :germany,
                "dk" => :denmark, "nl" => :netherlands, "fr" => :france, 
                "no" => :norway, "fi" => :finland, "nz" => :new_zealand,
                "au" => :austrailia, "se" => "sweden", "gb" => :uk, 
                "california" => :california}
   p = type_hash.values
   result = country == "random" ? rand_val(p) : type_hash[country]
   @country_code = get_country_code(result) if result
   return result
 end

  def get_country_code(country_sym)
    countries = {denmark: "DK", california: "US", sweden: "SE", uk: "UK",
                germany: "DE", finland: "FI", france: "FR", norway: "NO",
                new_zealand: "NZ", ireland: "IE", austrailia: "AU", netherlands: "NL",
                }
    return countries[country_sym]
  end

  def rand_val(possibilities)
    possibilities[rand()]
  end

  def no_prior_subscription
    :registered_no_prior
  end

  def a_multi_use_promo_code
    :multi_use_promo
  end

  def a_one_time_use_promo_code
    :one_time_use_promo
  end

  def months(number)
    (number + "_month").to_sym
  end

  def access_to_their_info
    :subject_user
  end

  def a_canceled_subscription
    :canceled
  end

  def an_active_subscription
    :registered_with_active
  end

  def an_active_subscription_with_tracking_information
    :registered_with_active_and_tracking
  end

  def simple_registered
    FactoryGirl.build(:user, :registered)
  end

  def simple_unregistered
    FactoryGirl.build(:user)
  end

  def admin_and_subject
    u = simple_admin 
    u.subject_user = $test.user
    u
  end

  def simple_admin
    u = FactoryGirl.build(:user, :admin)
    u
  end

  def get_user_from_db(type, trait)
    db = DBCon.new
    db.respond_to?(trait) ? result = db.send(trait) : result = nil
    if result && result["email"] != nil
      u = User.new($test)
      u.configure_from_input(result)
      u.need_sub = false
      db.finish
      return u
    else
      db.finish
      return nil
    end
  end

  def build
   u = nil
   u = get_user_from_db(@type, @trait) if @trait
   unless u
   u = self.send("simple_"+ @type) unless @trait
   u =  FactoryGirl.build(:user, @trait) if @trait && !(@type == "admin")
   u = admin_and_subject if @trait == :subject_user && @type == "admin"
   end
   u.trait = @trait
   u.country_code = @country_code
   u
  end

end
