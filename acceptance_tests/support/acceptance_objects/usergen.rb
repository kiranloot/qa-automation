class UserGen

  def initialize(type, arg_string)
    parse_args(type, arg_string) if arg_string
    set_simple(type) unless arg_string
  end

  def parse_args(type, arg_string)
    @location_trait = false
    @args = preprocess(arg_string)
    if args.class == String
      @args = @args.split(" ")
      @args = @args.join("_")
    end
    @type = type
    @location_trait ? @trait = @args : @trait = self.send(@args)
  end

  def set_simple(type)
    @type = type
  end

  def preprocess(args)
    a = address_check(args)
    m = months_check(args)
    @args = is_address(a[1]) if a
    @args =  months(m[1]) if m
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
   result = type == "random" ? rand_val(p) : type_hash[type] 
   return result
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

  def months(number)
    (number + "_months").to_sym
  end

  def access_to_their_info
    :subject_user
  end

  def a_canceled_subscription
    :canceled
  end

  def an_active_subscription
    :registered_no_prior
  end

  def simple_registered
    FactoryGirl.build(:user, :registered)
  end

  def simple_unregistered
    FactoryGirl.build(:user)
  end

  def admin_and_subject
    u = FactoryGirl.build(:user, :admin)
    u.subject_user = $test.user
  end

  def build
    self.send("simple_"+ type) unless @trait
    FactoryGirl.build(:user, @trait) if @trait && !(@type == "admin")
    admin_and_subject if @trait == :subject_user && @type == "admin"
  end

end